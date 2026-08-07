//+==================================================================+
//|                  5_OrderManagement.mqh                           |
//+==================================================================+

#ifndef __ORDERMANAGEMENT_MQH__
#define __ORDERMANAGEMENT_MQH__

#include <Trade/Trade.mqh>

extern CTrade trade;

//+------------------------------------------------------------------+
//| Function Prototypes                                              |
//+------------------------------------------------------------------+
bool OrderExists(string fibName,ulong &ticket);

bool PositionExists(string fibName);

bool HasActivePosition(string fibName);

bool ModifyPendingOrder(ulong ticket,double entry,double sl,double tp);

bool DeletePendingOrder(ulong ticket);

bool PendingOrderChanged(string fibName,double entry,double sl,double tp,double lots);

bool CancelOrder(string fibName);

void PrintModificationResult(bool result);

bool ExecuteOrder(string fibName,double entry,double sl,double tp,double lots);

//+------------------------------------------------------------------+
//| Position Exists                                                  |
//+------------------------------------------------------------------+
bool PositionExists(string fibName)
{
   int total = PositionsTotal();

   for(int i=0;i<total;i++)
   {
      ulong ticket = PositionGetTicket(i);

      if(ticket==0)
         continue;

      if(!PositionSelectByTicket(ticket))
         continue;

      if(PositionGetString(POSITION_SYMBOL)!=_Symbol)
         continue;

      if(PositionGetString(POSITION_COMMENT)!=fibName)
         continue;

      return(true);
   }

   return(false);
}

//+------------------------------------------------------------------+
//| Order Exists                                                     |
//+------------------------------------------------------------------+
bool OrderExists(string fibName,ulong &ticket)
{
   // Total Pending Orders
   int total = OrdersTotal();

   // Loop Through Pending Orders
   for(int i = 0; i < total; i++)
   {
      // Get Ticket
      ulong currentTicket = OrderGetTicket(i);

      if(currentTicket == 0)
         continue;

      // Select Order
      if(!OrderSelect(currentTicket))
         continue;

      // Check Symbol
      if(OrderGetString(ORDER_SYMBOL) != _Symbol)
         continue;

      // Check Comment
      if(OrderGetString(ORDER_COMMENT) != fibName)
         continue;

      // Matching Order Found
      ticket = currentTicket;

      return(true);
   }

   // No Matching Order Found
   ticket = 0;

   return(false);
}

//+------------------------------------------------------------------+
//| Pending Order Changed                                            |
//+------------------------------------------------------------------+
bool PendingOrderChanged(string fibName,
                         double entry,
                         double sl,
                         double tp,
                         double lots)
{
   ulong ticket;

   // Find existing pending order
   if(!OrderExists(fibName,ticket))
      return(true);

   // Select the order
   if(!OrderSelect(ticket))
      return(true);

   // Existing values
   double oldEntry = OrderGetDouble(ORDER_PRICE_OPEN);
   double oldSL    = OrderGetDouble(ORDER_SL);
   double oldTP    = OrderGetDouble(ORDER_TP);
   double oldLots  = OrderGetDouble(ORDER_VOLUME_CURRENT);
   int digits = (int)SymbolInfoInteger(_Symbol,SYMBOL_DIGITS);


   // Compare Entry
   if(NormalizeDouble(oldEntry,digits) != NormalizeDouble(entry,digits))
      return(true);

   // Compare SL
   if(NormalizeDouble(oldSL,digits) != NormalizeDouble(sl,digits))
      return(true);

   // Compare TP
   if(NormalizeDouble(oldTP,digits) != NormalizeDouble(tp,digits))
      return(true);

   // Compare Lots
   if(NormalizeDouble(oldLots,2) != NormalizeDouble(lots,2))
      return(true);

   // Nothing changed
   return(false);
   
}

//+------------------------------------------------------------------+
//| Active Position Exists                                           |
//+------------------------------------------------------------------+
bool HasActivePosition(string fibName)
{
   if(PositionExists(fibName))
   {
      // Nothing to print
      
      return(true);
   }

   // Nothing to print

   return(false);
}

//+------------------------------------------------------------------+
//| Modify Pending Order                                             |
//+------------------------------------------------------------------+
bool ModifyPendingOrder(ulong ticket,double entry,double sl,double tp)
{
   // Select Pending Order
   if(!OrderSelect(ticket))
   {
      Print("Failed to select pending order.");

      return(false);
   }

   // Modify Pending Order
   bool result;

   result = trade.OrderModify(ticket,entry,sl,tp,ORDER_TIME_GTC,0);

   // Check Result
   if(result)
   {
      // Nothing to print
   }
   else
   {
      Print("Failed to Modify Pending Order.");
   }

   return(result);
}

//+------------------------------------------------------------------+
//| Delete Pending Order                                             |
//+------------------------------------------------------------------+
bool DeletePendingOrder(ulong ticket)
{
   // Select Pending Order
   if(!OrderSelect(ticket))
   {
      // Nothing to print

      return(false);
   }

   // Delete Pending Order
   bool result;

   result = trade.OrderDelete(ticket);

   // Check Result
   if(result)
   {
      // Nothing to print
   }
   else
   {
      Print("Failed to Delete Pending Order.");
   }

   return(result);
}

//+------------------------------------------------------------------+
//| Cancel Order                                                     |
//+------------------------------------------------------------------+
bool CancelOrder(string fibName)
{
   // Order Ticket
   ulong ticket;

   // Check if Order Exists
   if(!OrderExists(fibName,ticket))
   {
      // Nothing to print

      return(false);
   }

   // Delete Pending Order
   return(DeletePendingOrder(ticket));
}

//+------------------------------------------------------------------+
//| Execute Order                                                    |
//+------------------------------------------------------------------+
bool ExecuteOrder(string fibName,
                  double entry,
                  double sl,
                  double tp,
                  double lots)
{
   // Existing Order Ticket
   ulong ticket;

   //==================================================
   // Existing Pending Order
   //==================================================

   if(OrderExists(fibName,ticket))
   {
      if(!DeletePendingOrder(ticket))
      {
         return(false);
      }
   }

   return(true);
}
//+------------------------------------------------------------------+
//| Print Modification Result                                        |
//+------------------------------------------------------------------+
void PrintModificationResult(bool result)
{

   if(result)
   {
      Print("Order Updated Successfullyy");
   }
   else
   {
      Print("Order Updated Failed");
   }
}

#endif