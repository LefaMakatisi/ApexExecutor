//+==================================================================+
//|                  4_OrderExecution.mqh                            |
//+==================================================================+
#ifndef __ORDEREXECUTION_MQH__
#define __ORDEREXECUTION_MQH__

#include <Trade/Trade.mqh>

extern CTrade trade;

//+------------------------------------------------------------------+
//| Function Prototypes                                              |
//+------------------------------------------------------------------+
bool PlacePendingOrder(string fibName,
                       double entry,
                       double sl,
                       double tp,
                       double lots);

bool ValidateOrder(double entry,
                   double sl,
                   double tp,
                   double lots);

ENUM_ORDER_TYPE DetectOrderType(double entry,
                                double sl,
                                double tp);

void PrintOrderSummary(string fibName,
                       ENUM_ORDER_TYPE orderType,
                       double entry,
                       double sl,
                       double tp,
                       double lots);

bool SendPendingOrder(ENUM_ORDER_TYPE orderType,
                      string fibName,
                      double entry,
                      double sl,
                      double tp,
                      double lots);

void PrintOrderResult(bool result);

//+------------------------------------------------------------------+
//| Place Pending Order                                              |
//+------------------------------------------------------------------+
bool PlacePendingOrder(string fibName,
                       double entry,
                       double sl,
                       double tp,
                       double lots)
{
   
   if(!ValidateOrder(entry,
                     sl,
                     tp,
                     lots))
   {
      return(false);
   }

   ENUM_ORDER_TYPE orderType;

   orderType = DetectOrderType(entry,
                               sl,
                               tp);

   PrintOrderSummary(fibName,
                     orderType,
                     entry,
                     sl,
                     tp,
                     lots);

   bool result;

   result = SendPendingOrder(orderType,
                             fibName,
                             entry,
                             sl,
                             tp,
                             lots);

   PrintOrderResult(result);
   return(result);
}

//+------------------------------------------------------------------+
//| Validate Order                                                   |
//+------------------------------------------------------------------+
bool ValidateOrder(double entry,
                   double sl,
                   double tp,
                   double lots)
{

   // Validate Entry
   if(entry <= 0)
   {
      Print("Validation Failed: Invalid Entry Price.");
      return(false);
   }

   // Validate Stop Loss
   if(sl <= 0)
   {
      Print("Validation Failed: Invalid Stop Loss.");
      return(false);
   }
   
   // Validate Take Profit
   if(tp <= 0)
   {
      Print("Validation Failed: Invalid Take Profit.");
      return(false);
   }

   // Validate Lot Size
   if(lots <= 0)
   {
      Print("Validation Failed: Invalid Lot Size.");
      return(false);
   }
   
   // Entry and Stop Loss cannot match
   if(entry == sl)
   {
      Print("Validation Failed: Entry equals Stop Loss.");
      return(false);
   }

   // Entry and Take Profit cannot match
   if(entry == tp)
   {
      Print("Validation Failed: Entry equals Take Profit.");
      return(false);
   }

   // Stop Loss and Take Profit cannot match
   if(sl == tp)
   {
      Print("Validation Failed: Stop Loss equals Take Profit.");
      return(false);
   }

   // Nothing to print
   
   return(true);
}

//+------------------------------------------------------------------+
//| Detect Order Type                                                |
//+------------------------------------------------------------------+
ENUM_ORDER_TYPE DetectOrderType(double entry,
                                double sl,
                                double tp)
{
   double bid = SymbolInfoDouble(_Symbol,SYMBOL_BID);
   double ask = SymbolInfoDouble(_Symbol,SYMBOL_ASK);

   //==================================================
   // BUY Setup
   //==================================================

   if(sl < entry && entry < tp)
   {
   
      // Buy Limit
      if(entry < ask)
      {

         return(ORDER_TYPE_BUY_LIMIT);
      }

      // Buy Stop
      if(entry > ask)
      {

         return(ORDER_TYPE_BUY_STOP);
      }
   }

   //==================================================
   // SELL Setup
   //==================================================

   if(tp < entry && entry < sl)
   {
      // Sell Limit
      if(entry > bid)
      {

         return(ORDER_TYPE_SELL_LIMIT);
      }
      
      // Sell Stop
      if(entry < bid)
      {

         return(ORDER_TYPE_SELL_STOP);
      }
   }

   Print("Failed to detect pending order type.");

   return(WRONG_VALUE);
}

//+------------------------------------------------------------------+
//| Print Order Summary                                              |
//+------------------------------------------------------------------+
void PrintOrderSummary(string fibName,
                       ENUM_ORDER_TYPE orderType,
                       double entry,
                       double sl,
                       double tp,
                       double lots)
{

   // Convert Order Type to Text
   string orderTypeText;

   switch(orderType)
   {
      case ORDER_TYPE_BUY_LIMIT:
         orderTypeText = "BUY LIMIT";
         break;

      case ORDER_TYPE_BUY_STOP:
         orderTypeText = "BUY STOP";
         break;

      case ORDER_TYPE_SELL_LIMIT:
         orderTypeText = "SELL LIMIT";
         break;

      case ORDER_TYPE_SELL_STOP:
         orderTypeText = "SELL STOP";
         break;

      default:
         orderTypeText = "UNKNOWN";
         break;
   }

   // Print Summary
   Print(" ============ Execution ============ " );
   Print("Symbol    : ", _Symbol);
   Print("Order Type: ", orderTypeText);
   Print("Lots      : ", DoubleToString(lots,2));
   Print(" =================================== " );
}

//+------------------------------------------------------------------+
//| Send Pending Order                                               |
//+------------------------------------------------------------------+
bool SendPendingOrder(ENUM_ORDER_TYPE orderType,
                      string fibName,
                      double entry,
                      double sl,
                      double tp,
                      double lots)
{

   // Order Comment
   string comment = fibName;

   //==================================================
   // Buy Limit
   //==================================================
    
   if(orderType == ORDER_TYPE_BUY_LIMIT)
   {
      return(trade.BuyLimit(lots,
                            entry,
                            _Symbol,
                            sl,
                            tp,
                            ORDER_TIME_GTC,
                            0,
                            comment));
   }

   //==================================================
   // Buy Stop
   //==================================================

   if(orderType == ORDER_TYPE_BUY_STOP)
   {
      return(trade.BuyStop(lots,
                           entry,
                           _Symbol,
                           sl,
                           tp,
                           ORDER_TIME_GTC,
                           0,
                           comment));
   }

   //==================================================
   // Sell Limit
   //==================================================

   if(orderType == ORDER_TYPE_SELL_LIMIT)
   {
      return(trade.SellLimit(lots,
                             entry,
                             _Symbol,
                             sl,
                             tp,
                             ORDER_TIME_GTC,
                             0,
                             comment));
   }
   
   //==================================================
   // Sell Stop
   //==================================================
   
   if(orderType == ORDER_TYPE_SELL_STOP)
   {
      return(trade.SellStop(lots,
                            entry,
                            _Symbol,
                            sl,
                            tp,
                            ORDER_TIME_GTC,
                            0,
                            comment));
   }

   // Unknown Order Type
   Print("Failed to send order. Unknown pending order type.");

   return(false);
}

//+------------------------------------------------------------------+
//| Print Order Result                                               |
//+------------------------------------------------------------------+
void PrintOrderResult(bool result)
{

   // Order Successful
   if(result)
   {
      // Nothing to print
      
      return;
   }
   
   // Order Failed
   Print("============= ORDER FAILED =============");
   Print("Retcode     : ", trade.ResultRetcode());
   Print("Description : ", trade.ResultRetcodeDescription());
   Print("========================================");
}

#endif