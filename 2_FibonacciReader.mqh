//+==================================================================+
//|                 2_FibonacciReader.mqh                            |
//+==================================================================+
#ifndef __FIBONACCIREADER_MQH__
#define __FIBONACCIREADER_MQH__

//+------------------------------------------------------------------+
//| Function Prototypes                                              |
//+------------------------------------------------------------------+
bool SaveFibState(string fibName,double entry,double sl,double tp);

bool LoadFibState(string &fibName,double &entry,double &sl,double &tp);

void DeleteFibState();

//+------------------------------------------------------------------+
//| Read Fibonacci Prices                                            |
//+------------------------------------------------------------------+
bool ReadFibPrices(string fibName,double &tp,double &entry,double &sl)
{
   if(ObjectFind(0,fibName)==-1)
   {
      Print("Fibonacci not found.");
      return false;
   }

   // Anchor prices
   double price1 = ObjectGetDouble(0,fibName,OBJPROP_PRICE,0);
   double price2 = ObjectGetDouble(0,fibName,OBJPROP_PRICE,1);

   // Difference
   double range = price2-price1;

   // Your mapping
   sl    = price1;
   tp    = price2;
   entry = price1 + range * 0.25;

   return true;
}

//+------------------------------------------------------------------+
//| Save Fibonacci State                                             |
//+------------------------------------------------------------------+
bool SaveFibState(string fibName,double entry,double sl,double tp)
{
   string fileName = _Symbol;

   int file = FileOpen(fileName,
                       FILE_WRITE|FILE_CSV,',');

   if(file == INVALID_HANDLE)
   {
      Print("Failed to create state file.");
      return(false);
   }

   FileWrite(file,fibName,entry,sl,tp);

   FileClose(file);
   
   Print("State saved: ", fileName);


   return(true);
}

//+------------------------------------------------------------------+
//| Load Fibonacci State                                             |
//+------------------------------------------------------------------+
bool LoadFibState(string &fibName,double &entry,double &sl,double &tp)
{
   string fileName = _Symbol;

   int file = FileOpen(fileName,
                       FILE_READ|FILE_CSV,
                       ',');

   if(file == INVALID_HANDLE)
   {
      return(false);
   }

   fibName = FileReadString(file);
   entry   = FileReadNumber(file);
   sl      = FileReadNumber(file);
   tp      = FileReadNumber(file);

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
      FileDelete(fileName);
}

#endif