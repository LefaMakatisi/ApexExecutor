//+------------------------------------------------------------------+
//|             Correlated Order Manager                             |
//+------------------------------------------------------------------+

#include <Trade/Trade.mqh>

extern CTrade trade;
//+------------------------------------------------------------------+
//| Get correlated counterpart                                       |
//+------------------------------------------------------------------+
string GetCorrelatedPair(string symbol)
{
   string base  = StringSubstr(symbol,0,3);
   string quote = StringSubstr(symbol,3,3);

   //==================================================
   // EUR <-> GBP
   //==================================================

   if(base == "EUR" && quote != "GBP")
   {
      return("GBP" + quote);
   }

   if(base == "GBP" && quote != "EUR")
   {
      return("EUR" + quote);
   }


   //==================================================
   // AUD <-> NZD
   //==================================================

   if(base == "AUD" && quote != "NZD")
   {
      return("NZD" + quote);
   }

   if(base == "NZD" && quote != "AUD")
   {
      return("AUD" + quote);
   }


   //==================================================
   // USD <-> CAD
   //==================================================

   if(base == "USD" && quote != "CAD")
   {
      return("CAD" + quote);
   }

   if(base == "CAD" && quote != "USD")
   {
      return("USD" + quote);
   }


   //==================================================
   // No correlated pair
   //==================================================

   return("");
}


//+------------------------------------------------------------------+
//| Delete correlated pending order                                 |
//+------------------------------------------------------------------+
void DeleteCorrelatedPendingOrder(string triggeredSymbol)
{
   string correlatedSymbol = GetCorrelatedPair(triggeredSymbol);

   if(correlatedSymbol == "")
   {
      return;
   }

   int total = OrdersTotal();

   for(int i = total - 1; i >= 0; i--)
   {
      ulong ticket = OrderGetTicket(i);

      if(ticket == 0)
      {
         continue;
      }

      if(!OrderSelect(ticket))
      {
         continue;
      }

      string symbol = OrderGetString(ORDER_SYMBOL);

      if(symbol != correlatedSymbol)
      {
         continue;
      }

      ENUM_ORDER_TYPE type =
         (ENUM_ORDER_TYPE)OrderGetInteger(ORDER_TYPE);

      bool isPending = false;

      if(type == ORDER_TYPE_BUY_LIMIT)
      {
         isPending = true;
      }

      if(type == ORDER_TYPE_SELL_LIMIT)
      {
         isPending = true;
      }

      if(type == ORDER_TYPE_BUY_STOP)
      {
         isPending = true;
      }

      if(type == ORDER_TYPE_SELL_STOP)
      {
         isPending = true;
      }

      if(type == ORDER_TYPE_BUY_STOP_LIMIT)
      {
         isPending = true;
      }

      if(type == ORDER_TYPE_SELL_STOP_LIMIT)
      {
         isPending = true;
      }

      if(!isPending)
      {
         continue;
      }

      bool deleted = trade.OrderDelete(ticket);

      if(deleted)
      {
         Print(
            "[Apex] Correlated pending order deleted: ",
            correlatedSymbol
         );
      }

      if(!deleted)
      {
         Print(
            "[Apex] Failed to delete correlated pending order: ",
            correlatedSymbol,
            " Ticket: ",
            ticket
         );
      }
   }
}