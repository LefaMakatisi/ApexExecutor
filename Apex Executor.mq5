//+==================================================================+
//|                      Apex Executor                               |
//+==================================================================+
#property strict
#property version   "1.00"

#include <Trade/Trade.mqh>

#include "1_ExecutionPanel.mqh"
#include "2_Fibonacci.mqh"
#include "3_RiskCalculator.mqh"
#include "4_OrderExecution.mqh"
#include "5_OrderManagement.mqh"

CTrade trade;

//+------------------------------------------------------------------+
//| Global Variables                                                 |
//+------------------------------------------------------------------+

string SelectedFib = "";
bool   HasSelection = false;


//+------------------------------------------------------------------+
//| Expert initialization                                            |
//+------------------------------------------------------------------+

int OnInit()
{
   Print("[Apex] Loaded");

   //==================================================
   // Enable chart events
   //==================================================

   ChartSetInteger(
      0,
      CHART_EVENT_OBJECT_CREATE,
      true
   );

   ChartSetInteger(
      0,
      CHART_EVENT_OBJECT_DELETE,
      true
   );

   //==================================================
   // Create Execution Panel
   //==================================================

   CreateExecutionPanel();

   //==================================================
   // Create Apex FIB button
   //==================================================

   CreateFibonacciButton();

   //==================================================
   // Do NOT create Fibonacci on startup
   //==================================================

   SelectedFib  = "";
   HasSelection = false;

   ChartRedraw();

   return(INIT_SUCCEEDED);
}


//+------------------------------------------------------------------+
//| Expert deinitialization                                          |
//+------------------------------------------------------------------+

void OnDeinit(const int reason)
{
   //==================================================
   // Remove Fibonacci only when EA is removed
   //==================================================

   if(reason == REASON_REMOVE)
   {
      DeleteFibState();

      if(ObjectFind(0,EA_FIB_NAME) != -1)
         ObjectDelete(0,EA_FIB_NAME);
   }

   //==================================================
   // Delete button
   //==================================================

   DeleteFibonacciButton();

   //==================================================
   // Delete panel
   //==================================================

   DeleteExecutionPanel();

   SelectedFib  = "";
   HasSelection = false;

   Print("[Apex] Removed");
}


//+------------------------------------------------------------------+
//| Tick                                                             |
//+------------------------------------------------------------------+

void OnTick()
{

}

//+------------------------------------------------------------------+
//| Chart Events                                                     |
//+------------------------------------------------------------------+

void OnChartEvent(
   const int id,
   const long &lparam,
   const double &dparam,
   const string &sparam)
{
   //==================================================
   // Fibonacci Deleted
   //==================================================

   if(id == CHARTEVENT_OBJECT_DELETE)
   {
      if(sparam == EA_FIB_NAME)
      {
         // Clear selected Fibonacci
         HasSelection = false;
         SelectedFib  = "";

         // Delete saved Fibonacci state
         DeleteFibState();

         // Keep the panel visible
         // Only clear the Fibonacci values
         ClearExecutionPanel();

         // Make sure panel exists
         if(ObjectFind(0,PANEL_NAME) == -1)
         {
            CreateExecutionPanel();
         }

         ChartRedraw();

         Print("[Apex] Apex FIB deleted. Panel cleared.");
      }

      return;
   }


   //==================================================
   // Fibonacci Dragged
   //==================================================

   if(id == CHARTEVENT_OBJECT_DRAG)
   {
      if(sparam == EA_FIB_NAME)
      {
         double tp;
         double entry;
         double sl;

         if(ReadFibPrices(
               EA_FIB_NAME,
               tp,
               entry,
               sl))
         {
            SaveFibState(
               EA_FIB_NAME,
               entry,
               sl,
               tp
            );

            UpdateExecutionPanel(
               EA_FIB_NAME,
               entry,
               sl,
               tp
            );

            ChartRedraw();
         }

         return;
      }
   }


   //==================================================
   // Object Click
   //==================================================

   if(id == CHARTEVENT_OBJECT_CLICK)
   {
      //==================================================
      // Apex FIB Button
      //==================================================

      if(sparam == EA_FIB_BUTTON)
      {
         //==================================================
         // If FIB already exists, select it
         //==================================================

         if(ObjectFind(0,EA_FIB_NAME) != -1)
         {
            SelectedFib  = EA_FIB_NAME;
            HasSelection = true;

            double tp;
            double entry;
            double sl;

            if(ReadFibPrices(
                  EA_FIB_NAME,
                  tp,
                  entry,
                  sl))
            {
               SaveFibState(
                  EA_FIB_NAME,
                  entry,
                  sl,
                  tp
               );

               UpdateExecutionPanel(
                  EA_FIB_NAME,
                  entry,
                  sl,
                  tp
               );
            }

            return;
         }


         //==================================================
         // FIB does not exist
         // Create it
         //==================================================

         if(CreateEAFibonacci())
         {
            SelectedFib  = EA_FIB_NAME;
            HasSelection = true;

            double tp;
            double entry;
            double sl;

            if(ReadFibPrices(
                  EA_FIB_NAME,
                  tp,
                  entry,
                  sl))
            {
               SaveFibState(
                  EA_FIB_NAME,
                  entry,
                  sl,
                  tp
               );

               UpdateExecutionPanel(
                  EA_FIB_NAME,
                  entry,
                  sl,
                  tp
               );
            }

            Print("[Apex] Apex FIB activated.");
         }

         return;
      }


      //==================================================
      // User clicked Apex FIB
      //==================================================

      if(sparam == EA_FIB_NAME)
      {
         SelectedFib  = EA_FIB_NAME;
         HasSelection = true;

         double tp;
         double entry;
         double sl;

         if(ReadFibPrices(
               EA_FIB_NAME,
               tp,
               entry,
               sl))
         {
            SaveFibState(
               EA_FIB_NAME,
               entry,
               sl,
               tp
            );

            UpdateExecutionPanel(
               EA_FIB_NAME,
               entry,
               sl,
               tp
            );
         }

         Print("[Apex] Apex FIB selected.");

         return;
      }


      //==================================================
      // Execute Button
      //==================================================

      if(sparam == BTN_EXECUTE)
      {
         if(!HasSelection)
         {
            Print("[Apex] No Fibonacci selected.");
            return;
         }


         //==================================================
         // Check Fibonacci exists
         //==================================================

         if(ObjectFind(
               0,
               EA_FIB_NAME) == -1)
         {
            Print(
               "[Apex] Apex FIB does not exist."
            );

            SelectedFib  = "";
            HasSelection = false;

            ClearExecutionPanel();

            return;
         }


         //==================================================
         // Read Fibonacci
         //==================================================

         double tp;
         double entry;
         double sl;

         if(!ReadFibPrices(
               EA_FIB_NAME,
               tp,
               entry,
               sl))
         {
            return;
         }


         //==================================================
         // Read Risk
         //==================================================

         string riskText =
            ObjectGetString(
               0,
               EDIT_RISK,
               OBJPROP_TEXT
            );

         double risk =
            StringToDouble(riskText);

         SaveRiskValue();


         //==================================================
         // Calculate Lots
         //==================================================

         double lots =
            CalculateLotSize(
               entry,
               sl,
               risk
            );

         if(lots <= 0)
         {
            Print("[Apex] Invalid lot size.");
            return;
         }


         //==================================================
         // Existing Order Ticket
         //==================================================

         ulong ticket;

         bool result;


         //==================================================
         // Active Position Protection
         //==================================================

         if(HasActivePosition(EA_FIB_NAME))
         {
            Print("[Apex] Open Trade Running.");
            return;
         }


         //==================================================
         // Existing Pending Order
         //==================================================

         if(OrderExists(
               EA_FIB_NAME,
               ticket))
         {
            if(!PendingOrderChanged(
                  EA_FIB_NAME,
                  entry,
                  sl,
                  tp,
                  lots))
            {
               Print(
                  "[Apex] Pending Order Already Up To Date."
               );

               result = true;
            }
            else
            {
               if(DeletePendingOrder(ticket))
               {
                  result =
                     PlacePendingOrder(
                        EA_FIB_NAME,
                        entry,
                        sl,
                        tp,
                        lots
                     );
               }
               else
               {
                  result = false;
               }
            }
         }
         else
         {
            result =
               PlacePendingOrder(
                  EA_FIB_NAME,
                  entry,
                  sl,
                  tp,
                  lots
               );
         }


         //==================================================
         // Final Result
         //==================================================

         if(!result)
         {
            Print("[Apex] Execution Failed.");
         }

         return;
      }
   }
}