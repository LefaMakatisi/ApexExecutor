//+==================================================================+
//|                      Apex Executor                               |
//+==================================================================+
#property strict
#property version   "1.00"

#include <Trade/Trade.mqh>
#include "1_ExecutionPanel.mqh"
#include "2_FibonacciReader.mqh"
#include "3_RiskCalculator.mqh"
#include "4_OrderExecution.mqh"
#include "5_OrderManagement.mqh"
#include "6_CorrelatedOrderManager.mqh"

CTrade trade;

// Global Variables
string SelectedFib = "";
bool HasSelection = false;

//+------------------------------------------------------------------+
//| Expert initialization                                            |
//+------------------------------------------------------------------+
int OnInit()
{
   Print("[Apex] Loaded");

   ChartSetInteger(0,CHART_EVENT_OBJECT_CREATE,true);
   ChartSetInteger(0,CHART_EVENT_OBJECT_DELETE,true);

   CreateExecutionPanel();

   double entry;
   double sl;
   double tp;

   if(LoadFibState(SelectedFib,entry,sl,tp))
   {
      HasSelection = true;

      UpdateExecutionPanel(SelectedFib,entry,sl,tp);
}
   ScanFibObjects();

   return(INIT_SUCCEEDED);
} 

//+------------------------------------------------------------------+
//| Expert deinitialization                                          |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   if(reason == REASON_REMOVE)
      DeleteFibState();
   
   DeleteExecutionPanel();

   SelectedFib = "";
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
//| Trade Transaction                                                |
//+------------------------------------------------------------------+
void OnTradeTransaction(
   const MqlTradeTransaction &trans,
   const MqlTradeRequest &request,
   const MqlTradeResult &result)
{
   // Only process newly created deals
   if(trans.type != TRADE_TRANSACTION_DEAL_ADD)
      return;

   ulong dealTicket = trans.deal;

   if(dealTicket == 0)
      return;

   if(!HistoryDealSelect(dealTicket))
      return;

   // Check that the deal opened a position
   ENUM_DEAL_ENTRY entry =
      (ENUM_DEAL_ENTRY)HistoryDealGetInteger(
         dealTicket,
         DEAL_ENTRY
      );

   if(entry != DEAL_ENTRY_IN)
      return;

   // Get the symbol that was triggered
   string triggeredSymbol =
      HistoryDealGetString(
         dealTicket,
         DEAL_SYMBOL
      );

   if(triggeredSymbol == "")
      return;

   // Delete its correlated pending order
   DeleteCorrelatedPendingOrder(triggeredSymbol);
}

//+------------------------------------------------------------------------------------------+
//| Chart Events                                                                             |
//+------------------------------------------------------------------------------------------+
void OnChartEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
                  
 {
   switch(id)
   {
      case CHARTEVENT_OBJECT_CREATE:

         if(ObjectGetInteger(0,sparam,OBJPROP_TYPE)==OBJ_FIBO)
         {
            // Nothing to print

         }

         break;

       case CHARTEVENT_OBJECT_DELETE:
 
         Print("Deleted: ", sparam);

       if(HasSelection && SelectedFib == sparam)
    {
      DeleteFibState();
      SelectedFib = "";
      HasSelection = false;
      ClearExecutionPanel();

      Print("Selection cleared.");
   }

   break;

      case CHARTEVENT_OBJECT_DRAG:

         // Next:
         // Move Execute Button

         break;

case CHARTEVENT_OBJECT_CLICK:

   if(ObjectFind(0,sparam)!=-1)
   {
      // User clicked a Fibonacci
      if(ObjectGetInteger(0,sparam,OBJPROP_TYPE)==OBJ_FIBO)
      {
         SelectedFib = sparam;
         HasSelection = true;

         double tp;
         double entry;
         double sl;
         
    // Read Fib Prices
    if(ReadFibPrices(SelectedFib,tp,entry,sl))
{
    SaveFibState(SelectedFib,entry,sl,tp);

    UpdateExecutionPanel(SelectedFib,entry,sl,tp);
}

   Print("Selected: ", SelectedFib);
}

      // User clicked the Execute button
      if(sparam == BTN_EXECUTE)
      {
         // No Fibonacci selected
         if(!HasSelection)
         {
            Print("No Fibonacci selected.");
            break;
         }

         // Selected Fibonacci no longer exists
         if(ObjectFind(0, SelectedFib) == -1)
         {
            SelectedFib = "";
            HasSelection = false;

            // Nothing to print
            
            break;
         }

         double tp;
         double entry;
         double sl;

         if(ReadFibPrices(SelectedFib,tp,entry,sl))
         {
           // Read Risk from the edit box
           string riskText = ObjectGetString(0,EDIT_RISK,OBJPROP_TEXT);

           double risk = StringToDouble(riskText);
           SaveRiskValue();
           
           // Calculate lots using the entered risk
           double lots = CalculateLotSize(entry,sl,risk);

   //==================================================
   // Existing Order Ticket
   //==================================================
     ulong ticket;

   //==================================================
   // Execution Result
   //==================================================
     bool result;

   //==================================================
   // Active Position Protection
   //==================================================
     if(HasActivePosition(SelectedFib))
   {
     Print("Open Trade Running");
   
     break;
   }

   //==================================================
   // Existing Pending Order
   //==================================================
     if(OrderExists(SelectedFib,ticket))
   {
     if(!PendingOrderChanged(SelectedFib,entry,sl,tp,lots))
   {
      Print("Pending Order Already Up To Date.");

      result = true;
   }
      else
   {
      if(DeletePendingOrder(ticket))
      {
         result = PlacePendingOrder(SelectedFib,entry,sl,tp,lots);
      }
      else
      {
         result = false;
      }
     }
    }
       else
    {
           result = PlacePendingOrder(SelectedFib,entry,sl,tp,lots);
    }


   //==================================================
   // Final Result
   //==================================================
     if(result)
    {
       // Nothing to print
    }
     else
    {
         Print("Execution Failed.");
    }

        }
      }
    }

     break;
    }
   }
//+------------------------------------------------------------------+
//| Scan Existing Fibonacci Objects                                  |
//+------------------------------------------------------------------+
void ScanFibObjects()
{
   int total = ObjectsTotal(0);

   for(int i=0;i<total;i++)
   {
      string name = ObjectName(0,i);

      if(ObjectGetInteger(0,name,OBJPROP_TYPE)==OBJ_FIBO)
      {
         // Nothing to print

      }
   }
}
