//+==================================================================+
//|                  3_RiskCalculator.mqh                            |
//+==================================================================+
#ifndef __RISKCALCULATOR_MQH__
#define __RISKCALCULATOR_MQH__

//+------------------------------------------------------------------+
//| Function Prototypes                                              |
//+------------------------------------------------------------------+
double NormalizeLotSize(double lots);

double CalculateLotSize(double entry,
                        double sl,
                        double riskAmount);

//+------------------------------------------------------------------+
//| Calculate Lot Size                                               |
//+------------------------------------------------------------------+
double CalculateLotSize(double entry,
                        double sl,
                        double riskAmount)
{
   // Distance between Entry and Stop Loss
   double stopDistance = MathAbs(entry - sl);

   if(stopDistance <= 0)
   {
      Print("Invalid Stop Loss distance.");
      return 0;
   }

   // Symbol properties
   double tickValue = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_VALUE);
   double tickSize  = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE);

   if(tickValue <= 0 || tickSize <= 0)
   {
      Print("Failed to read symbol properties.");
      return 0;
   }

   // Money risked by 1 lot
   double riskPerLot = (stopDistance / tickSize) * tickValue;

   if(riskPerLot <= 0)
      return 0;

   // Calculate Raw Lots
   double lots = riskAmount / riskPerLot;

   // Normalize Lot Size
   lots = NormalizeLotSize(lots);

return lots;
}

//+------------------------------------------------------------------+
//| Normalize Lot Size                                               |
//+------------------------------------------------------------------+
double NormalizeLotSize(double lots)
{

   // Read Broker Limits
   double minLot  = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
   double maxLot  = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MAX);
   double lotStep = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP);

   // Clamp to Broker Limits
   if(lots < minLot)
      lots = minLot;

   if(lots > maxLot)
      lots = maxLot;

   // Round to Broker Step
   lots = MathFloor(lots / lotStep) * lotStep;

   // Normalize Decimal Places
   int digits = 0;

   if(lotStep == 1.0)
      digits = 0;
   else if(lotStep == 0.1)
      digits = 1;
   else if(lotStep == 0.01)
      digits = 2;
   else if(lotStep == 0.001)
      digits = 3;
   else
      digits = 2;

   lots = NormalizeDouble(lots, digits);

   // Return Normalized Lots
   return lots;
}

#endif