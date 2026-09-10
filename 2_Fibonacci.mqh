//+==================================================================+
//|                 2_Fibonacci.mqh                                  |
//+==================================================================+
#ifndef __FIBONACCIREADER_MQH__
#define __FIBONACCIREADER_MQH__

//+------------------------------------------------------------------+
//| EA Fibonacci Settings                                            |
//+------------------------------------------------------------------+

#define EA_FIB_NAME   "Apex FIB"
#define EA_FIB_BUTTON "APEX_FIB_BUTTON"

input double FibTPLevel     = 0.00;
input double FibEntryLevel  = 0.75;
input double FibSLLevel     = 1.00;


//+------------------------------------------------------------------+
//| Function Prototypes                                              |
//+------------------------------------------------------------------+

bool CreateEAFibonacci();

bool ReadFibPrices(string fibName,
                   double &tp,
                   double &entry,
                   double &sl);

bool SaveFibState(string fibName,
                  double entry,
                  double sl,
                  double tp);

bool LoadFibState(string &fibName,
                  double &entry,
                  double &sl,
                  double &tp);

void DeleteFibState();

void CreateFibonacciButton();

void DeleteFibonacciButton();


//+------------------------------------------------------------------+
//| Create EA Fibonacci                                              |
//+------------------------------------------------------------------+

bool CreateEAFibonacci()
{
   //==================================================
   // Check if Fibonacci already exists
   //==================================================

   if(ObjectFind(0,EA_FIB_NAME) != -1)
      return(true);


   //==================================================
   // Check chart data
   //==================================================

   int bars = Bars(_Symbol,_Period);

   if(bars < 21)
   {
      Print("[Apex] Not enough chart data.");
      return(false);
   }


   //==================================================
   // Default Fibonacci anchors
   //==================================================

   int firstBar  = 20;
   int secondBar = 0;


   datetime time1 =
      iTime(_Symbol,
            _Period,
            firstBar);

   datetime time2 =
      iTime(_Symbol,
            _Period,
            secondBar);


   if(time1 == 0 || time2 == 0)
   {
      Print("[Apex] Failed to get Fibonacci anchor times.");
      return(false);
   }


   //==================================================
   // Default Fibonacci prices
   //==================================================

   double price1 =
      iLow(_Symbol,
           _Period,
           firstBar);

   double price2 =
      iHigh(_Symbol,
            _Period,
            secondBar);


   if(price1 <= 0 || price2 <= 0)
   {
      Print("[Apex] Failed to get Fibonacci anchor prices.");
      return(false);
   }


   //==================================================
   // Create Fibonacci
   //==================================================

   if(!ObjectCreate(0,
                    EA_FIB_NAME,
                    OBJ_FIBO,
                    0,
                    time1,
                    price1,
                    time2,
                    price2))
   {
      Print("[Apex] Failed to create Apex FIB.");
      return(false);
   }


   //==================================================
   // Fibonacci appearance
   //==================================================

   ObjectSetInteger(0,
                    EA_FIB_NAME,
                    OBJPROP_COLOR,
                    clrRed);

   ObjectSetInteger(0,
                    EA_FIB_NAME,
                    OBJPROP_WIDTH,
                    1);

   ObjectSetInteger(0,
                    EA_FIB_NAME,
                    OBJPROP_STYLE,
                    STYLE_SOLID);


   //==================================================
   // Make Fibonacci selectable and draggable
   //==================================================

   ObjectSetInteger(0,
                    EA_FIB_NAME,
                    OBJPROP_SELECTABLE,
                    true);

   ObjectSetInteger(0,
                    EA_FIB_NAME,
                    OBJPROP_SELECTED,
                    true);

   ObjectSetInteger(0,
                    EA_FIB_NAME,
                    OBJPROP_HIDDEN,
                    false);

   ObjectSetInteger(0,
                    EA_FIB_NAME,
                    OBJPROP_RAY_RIGHT,
                    false);


   //==================================================
   // Fibonacci levels
   //==================================================

   ObjectSetInteger(0,
                    EA_FIB_NAME,
                    OBJPROP_LEVELS,
                    3);


   //==================================================
   // TP
   //==================================================

   ObjectSetDouble(0,
                   EA_FIB_NAME,
                   OBJPROP_LEVELVALUE,
                   0,
                   FibTPLevel);

   ObjectSetString(0,
                   EA_FIB_NAME,
                   OBJPROP_LEVELTEXT,
                   0,
                   "TP");


   //==================================================
   // Entry
   //==================================================

   ObjectSetDouble(0,
                   EA_FIB_NAME,
                   OBJPROP_LEVELVALUE,
                   1,
                   FibEntryLevel);

   ObjectSetString(0,
                   EA_FIB_NAME,
                   OBJPROP_LEVELTEXT,
                   1,
                   "Entry");


   //==================================================
   // SL
   //==================================================

   ObjectSetDouble(0,
                   EA_FIB_NAME,
                   OBJPROP_LEVELVALUE,
                   2,
                   FibSLLevel);

   ObjectSetString(0,
                   EA_FIB_NAME,
                   OBJPROP_LEVELTEXT,
                   2,
                   "SL");


   //==================================================
   // Level appearance
   //==================================================

   ObjectSetInteger(0,
                    EA_FIB_NAME,
                    OBJPROP_LEVELCOLOR,
                    clrYellow);


   ChartRedraw();

   Print("[Apex] Apex FIB created.");

   return(true);
}


//+------------------------------------------------------------------+
//| Read Fibonacci Prices                                            |
//+------------------------------------------------------------------+

bool ReadFibPrices(string fibName,
                   double &tp,
                   double &entry,
                   double &sl)
{
   //==================================================
   // Check Fibonacci
   //==================================================

   if(ObjectFind(0,fibName) == -1)
   {
      Print("[Apex] Apex FIB not found.");
      return(false);
   }


   //==================================================
   // Read anchor prices
   //==================================================

   double price1 =
      ObjectGetDouble(0,
                      fibName,
                      OBJPROP_PRICE,
                      0);

   double price2 =
      ObjectGetDouble(0,
                      fibName,
                      OBJPROP_PRICE,
                      1);


   if(price1 <= 0 || price2 <= 0)
   {
      Print("[Apex] Invalid Fibonacci anchor prices.");
      return(false);
   }


   //==================================================
   // Read ACTUAL Fibonacci levels
   //==================================================

   double tpLevel =
      ObjectGetDouble(0,
                      fibName,
                      OBJPROP_LEVELVALUE,
                      0);

   double entryLevel =
      ObjectGetDouble(0,
                      fibName,
                      OBJPROP_LEVELVALUE,
                      1);

   double slLevel =
      ObjectGetDouble(0,
                      fibName,
                      OBJPROP_LEVELVALUE,
                      2);


   //==================================================
   // Calculate Fibonacci range
   //==================================================

   double range =
      price2 - price1;


   if(range == 0)
   {
      Print("[Apex] Fibonacci range is zero.");
      return(false);
   }


   //==================================================
   // Calculate TP
   //==================================================

   sl =
      price1 +
      range * tpLevel;


   //==================================================
   // Calculate Entry
   //==================================================

   double entryCoefficient =
      1.0 - entryLevel;

   entry =
      price1 +
      range * entryCoefficient;


   //==================================================
   // Calculate SL
   //==================================================

   tp =
      price1 +
      range * slLevel;


   //==================================================
   // Normalize prices
   //==================================================

   tp =
      NormalizeDouble(tp,_Digits);

   entry =
      NormalizeDouble(entry,_Digits);

   sl =
      NormalizeDouble(sl,_Digits);


   //==================================================
   // Validate calculated prices
   //==================================================

   if(tp <= 0 ||
      entry <= 0 ||
      sl <= 0)
   {
      Print("[Apex] Invalid calculated Fibonacci prices.");
      return(false);
   }


   return(true);
}


//+------------------------------------------------------------------+
//| Save Fibonacci State                                             |
//+------------------------------------------------------------------+

bool SaveFibState(string fibName,
                  double entry,
                  double sl,
                  double tp)
{
   string fileName = _Symbol;


   int file =
      FileOpen(fileName,
               FILE_WRITE|FILE_CSV,
               ',');


   if(file == INVALID_HANDLE)
   {
      Print("[Apex] Failed to save Fibonacci state.");
      return(false);
   }


   FileWrite(file,
             fibName,
             entry,
             sl,
             tp);


   FileClose(file);

   return(true);
}


//+------------------------------------------------------------------+
//| Load Fibonacci State                                             |
//+------------------------------------------------------------------+

bool LoadFibState(string &fibName,
                  double &entry,
                  double &sl,
                  double &tp)
{
   string fileName = _Symbol;


   int file =
      FileOpen(fileName,
               FILE_READ|FILE_CSV,
               ',');


   if(file == INVALID_HANDLE)
      return(false);


   fibName =
      FileReadString(file);

   entry =
      FileReadNumber(file);

   sl =
      FileReadNumber(file);

   tp =
      FileReadNumber(file);


   FileClose(file);

   return(true);
}


//+------------------------------------------------------------------+
//| Delete Fibonacci State                                           |
//+------------------------------------------------------------------+

void DeleteFibState()
{
   string fileName = _Symbol;


   if(FileIsExist(fileName))
   {
      FileDelete(fileName);
   }
}


//+------------------------------------------------------------------+
//| Create Apex FIB Button                                           |
//+------------------------------------------------------------------+

void CreateFibonacciButton()
{
   //==================================================
   // Do not create duplicate button
   //==================================================

   if(ObjectFind(0,EA_FIB_BUTTON) != -1)
      return;


   //==================================================
   // Create button
   //==================================================

   if(!ObjectCreate(0,
                    EA_FIB_BUTTON,
                    OBJ_BUTTON,
                    0,
                    0,
                    0))
   {
      Print("[Apex] Failed to create Apex FIB button.");
      return;
   }


   //==================================================
   // Button position
   //==================================================

   ObjectSetInteger(0,
                    EA_FIB_BUTTON,
                    OBJPROP_CORNER,
                    CORNER_LEFT_UPPER);

   ObjectSetInteger(0,
                    EA_FIB_BUTTON,
                    OBJPROP_XDISTANCE,
                    15);

   ObjectSetInteger(0,
                    EA_FIB_BUTTON,
                    OBJPROP_YDISTANCE,
                    35);


   //==================================================
   // Button size
   //==================================================

   ObjectSetInteger(0,
                    EA_FIB_BUTTON,
                    OBJPROP_XSIZE,
                    95);

   ObjectSetInteger(0,
                    EA_FIB_BUTTON,
                    OBJPROP_YSIZE,
                    25);


   //==================================================
   // Button text
   //==================================================

   ObjectSetString(0,
                   EA_FIB_BUTTON,
                   OBJPROP_TEXT,
                   "Apex FIB");


   //==================================================
   // Button appearance
   //==================================================

   ObjectSetInteger(0,
                    EA_FIB_BUTTON,
                    OBJPROP_COLOR,
                    clrBlack);

   ObjectSetInteger(0,
                    EA_FIB_BUTTON,
                    OBJPROP_BGCOLOR,
                    clrLightGray);

   ObjectSetInteger(0,
                    EA_FIB_BUTTON,
                    OBJPROP_BORDER_COLOR,
                    clrBlack);


   //==================================================
   // Button behaviour
   //==================================================

   ObjectSetInteger(0,
                    EA_FIB_BUTTON,
                    OBJPROP_SELECTABLE,
                    false);

   ObjectSetInteger(0,
                    EA_FIB_BUTTON,
                    OBJPROP_HIDDEN,
                    false);


   ChartRedraw();
}


//+------------------------------------------------------------------+
//| Delete Apex FIB Button                                           |
//+------------------------------------------------------------------+

void DeleteFibonacciButton()
{
   if(ObjectFind(0,EA_FIB_BUTTON) != -1)
   {
      ObjectDelete(0,
                   EA_FIB_BUTTON);
   }

   ChartRedraw();
}


#endif