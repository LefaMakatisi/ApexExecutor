//+==================================================================+
//|                 1_ExecutionPanel.mqh                             |
//+==================================================================+
#ifndef __EXECUTIONPANEL_MQH__
#define __EXECUTIONPANEL_MQH__

#define PANEL_NAME      "EXEC_PANEL"
#define BTN_EXECUTE     "EXEC_PANEL_BUTTON"
#define EDIT_RISK       "EXEC_PANEL_RISK"

#define RISK_GLOBAL     "APEX_EXECUTOR_RISK"

// Panel Position
int x = 280;
int y = 40;

//+------------------------------------------------------------------+
//|Create Panel                                                      |
//+------------------------------------------------------------------+
bool CreateExecutionPanel()
{
    DeleteExecutionPanel();
    
   //==================================================
   // Background
   //==================================================

   ObjectCreate(0,PANEL_NAME,OBJ_RECTANGLE_LABEL,0,0,0);

   ObjectSetInteger(0,PANEL_NAME,OBJPROP_CORNER,CORNER_RIGHT_UPPER);
   ObjectSetInteger(0,PANEL_NAME,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(0,PANEL_NAME,OBJPROP_YDISTANCE,y);

   ObjectSetInteger(0,PANEL_NAME,OBJPROP_XSIZE,260);
   ObjectSetInteger(0,PANEL_NAME,OBJPROP_YSIZE,230);

   ObjectSetInteger(0,PANEL_NAME,OBJPROP_BGCOLOR,clrLightGray);
   ObjectSetInteger(0,PANEL_NAME,OBJPROP_BORDER_COLOR,clrBlack);
   
   //==================================================
   // Title
   //==================================================

   ObjectCreate(0,"EXEC_TITLE",OBJ_LABEL,0,0,0);

   ObjectSetInteger(0,"EXEC_TITLE",OBJPROP_CORNER,CORNER_RIGHT_UPPER);
   ObjectSetInteger(0,"EXEC_TITLE",OBJPROP_XDISTANCE,x-40);
   ObjectSetInteger(0,"EXEC_TITLE",OBJPROP_YDISTANCE,y+10);

   ObjectSetString(0,"EXEC_TITLE",OBJPROP_TEXT,"ORDER EXECUTION");
   ObjectSetInteger(0,"EXEC_TITLE",OBJPROP_COLOR,clrBrown);
   
   //==================================================
   // Fib Label
   //==================================================

   ObjectCreate(0,"EXEC_FIB_LABEL",OBJ_LABEL,0,0,0);

   ObjectSetInteger(0,"EXEC_FIB_LABEL",OBJPROP_CORNER,CORNER_RIGHT_UPPER);
   ObjectSetInteger(0,"EXEC_FIB_LABEL",OBJPROP_XDISTANCE,x-15);
   ObjectSetInteger(0,"EXEC_FIB_LABEL",OBJPROP_YDISTANCE,y+45);

   ObjectSetString(0,"EXEC_FIB_LABEL",OBJPROP_TEXT,"Fib :");
   ObjectSetInteger(0,"EXEC_FIB_LABEL",OBJPROP_COLOR,clrBlack);

   //==================================================
   // Fib Value
   //==================================================

   ObjectCreate(0,"EXEC_FIB_VALUE",OBJ_LABEL,0,0,0);

   ObjectSetInteger(0,"EXEC_FIB_VALUE",OBJPROP_CORNER,CORNER_RIGHT_UPPER);
   ObjectSetInteger(0,"EXEC_FIB_VALUE",OBJPROP_XDISTANCE,x-80);
   ObjectSetInteger(0,"EXEC_FIB_VALUE",OBJPROP_YDISTANCE,y+45);

   ObjectSetString(0,"EXEC_FIB_VALUE",OBJPROP_TEXT,"");
   ObjectSetInteger(0,"EXEC_FIB_VALUE",OBJPROP_COLOR,clrBlack);
   
   //==================================================
   // Entry Label
   //==================================================

   ObjectCreate(0,"EXEC_ENTRY_LABEL",OBJ_LABEL,0,0,0);

   ObjectSetInteger(0,"EXEC_ENTRY_LABEL",OBJPROP_CORNER,CORNER_RIGHT_UPPER);
   ObjectSetInteger(0,"EXEC_ENTRY_LABEL",OBJPROP_XDISTANCE,x-15);
   ObjectSetInteger(0,"EXEC_ENTRY_LABEL",OBJPROP_YDISTANCE,y+70);

   ObjectSetString(0,"EXEC_ENTRY_LABEL",OBJPROP_TEXT,"Entry :");
   ObjectSetInteger(0,"EXEC_ENTRY_LABEL",OBJPROP_COLOR,clrBlack);

   //==================================================
   // Entry Value
   //==================================================

   ObjectCreate(0,"EXEC_ENTRY_VALUE",OBJ_LABEL,0,0,0);

   ObjectSetInteger(0,"EXEC_ENTRY_VALUE",OBJPROP_CORNER,CORNER_RIGHT_UPPER);
   ObjectSetInteger(0,"EXEC_ENTRY_VALUE",OBJPROP_XDISTANCE,x-80);
   ObjectSetInteger(0,"EXEC_ENTRY_VALUE",OBJPROP_YDISTANCE,y+70);

   ObjectSetString(0,"EXEC_ENTRY_VALUE",OBJPROP_TEXT,"");
   ObjectSetInteger(0,"EXEC_ENTRY_VALUE",OBJPROP_COLOR,clrBlack);
   
   //==================================================
   // SL Label
   //==================================================

   ObjectCreate(0,"EXEC_SL_LABEL",OBJ_LABEL,0,0,0);

   ObjectSetInteger(0,"EXEC_SL_LABEL",OBJPROP_CORNER,CORNER_RIGHT_UPPER);
   ObjectSetInteger(0,"EXEC_SL_LABEL",OBJPROP_XDISTANCE,x-15);
   ObjectSetInteger(0,"EXEC_SL_LABEL",OBJPROP_YDISTANCE,y+95);

   ObjectSetString(0,"EXEC_SL_LABEL",OBJPROP_TEXT,"SL :");
   ObjectSetInteger(0,"EXEC_SL_LABEL",OBJPROP_COLOR,clrBlack);

   //==================================================
   // SL Value
   //==================================================

   ObjectCreate(0,"EXEC_SL_VALUE",OBJ_LABEL,0,0,0);

   ObjectSetInteger(0,"EXEC_SL_VALUE",OBJPROP_CORNER,CORNER_RIGHT_UPPER);
   ObjectSetInteger(0,"EXEC_SL_VALUE",OBJPROP_XDISTANCE,x-80);
   ObjectSetInteger(0,"EXEC_SL_VALUE",OBJPROP_YDISTANCE,y+95);

   ObjectSetString(0,"EXEC_SL_VALUE",OBJPROP_TEXT,"");
   ObjectSetInteger(0,"EXEC_SL_VALUE",OBJPROP_COLOR,clrBlack);
   
   //==================================================
   // TP Label
   //==================================================

   ObjectCreate(0,"EXEC_TP_LABEL",OBJ_LABEL,0,0,0);

   ObjectSetInteger(0,"EXEC_TP_LABEL",OBJPROP_CORNER,CORNER_RIGHT_UPPER);
   ObjectSetInteger(0,"EXEC_TP_LABEL",OBJPROP_XDISTANCE,x-15);
   ObjectSetInteger(0,"EXEC_TP_LABEL",OBJPROP_YDISTANCE,y+120);

   ObjectSetString(0,"EXEC_TP_LABEL",OBJPROP_TEXT,"TP :");
   ObjectSetInteger(0,"EXEC_TP_LABEL",OBJPROP_COLOR,clrBlack);

   //==================================================
   // TP Value
   //==================================================

   ObjectCreate(0,"EXEC_TP_VALUE",OBJ_LABEL,0,0,0);

   ObjectSetInteger(0,"EXEC_TP_VALUE",OBJPROP_CORNER,CORNER_RIGHT_UPPER);
   ObjectSetInteger(0,"EXEC_TP_VALUE",OBJPROP_XDISTANCE,x-80);
   ObjectSetInteger(0,"EXEC_TP_VALUE",OBJPROP_YDISTANCE,y+120);

   ObjectSetString(0,"EXEC_TP_VALUE",OBJPROP_TEXT,"");
   ObjectSetInteger(0,"EXEC_TP_VALUE",OBJPROP_COLOR,clrBlack);
   
   //==================================================
   // Risk Label
   //==================================================

   ObjectCreate(0,"EXEC_RISK_LABEL",OBJ_LABEL,0,0,0);

   ObjectSetInteger(0,"EXEC_RISK_LABEL",OBJPROP_CORNER,CORNER_RIGHT_UPPER);
   ObjectSetInteger(0,"EXEC_RISK_LABEL",OBJPROP_XDISTANCE,x-15);
   ObjectSetInteger(0,"EXEC_RISK_LABEL",OBJPROP_YDISTANCE,y+150);

   ObjectSetString(0,"EXEC_RISK_LABEL",OBJPROP_TEXT,"Risk :");
   ObjectSetInteger(0,"EXEC_RISK_LABEL",OBJPROP_COLOR,clrBlack);
   
   //==================================================
   // Risk Edit Box
   //==================================================

   ObjectCreate(0,EDIT_RISK,OBJ_EDIT,0,0,0);

   ObjectSetInteger(0,EDIT_RISK,OBJPROP_CORNER,CORNER_RIGHT_UPPER);
   ObjectSetInteger(0,EDIT_RISK,OBJPROP_XDISTANCE,x-80);
   ObjectSetInteger(0,EDIT_RISK,OBJPROP_YDISTANCE,y+150);

   ObjectSetInteger(0,EDIT_RISK,OBJPROP_XSIZE,110);
   ObjectSetInteger(0,EDIT_RISK,OBJPROP_YSIZE,22);

   double risk = 0.0;
   if(GlobalVariableCheck(RISK_GLOBAL))
   risk = GlobalVariableGet(RISK_GLOBAL);
   ObjectSetString(0,EDIT_RISK,OBJPROP_TEXT,DoubleToString(risk,2));

   ObjectSetInteger(0,EDIT_RISK,OBJPROP_COLOR,clrBlack);
   ObjectSetInteger(0,EDIT_RISK,OBJPROP_BGCOLOR,clrWhite);
   ObjectSetInteger(0,EDIT_RISK,OBJPROP_BORDER_COLOR,clrBlack);
   
   //==================================================
   // Currency Label
   //==================================================

   ObjectCreate(0,"EXEC_CURRENCY",OBJ_LABEL,0,0,0);

   ObjectSetInteger(0,"EXEC_CURRENCY",OBJPROP_CORNER,CORNER_RIGHT_UPPER);
   ObjectSetInteger(0,"EXEC_CURRENCY",OBJPROP_XDISTANCE,x-195);
   ObjectSetInteger(0,"EXEC_CURRENCY",OBJPROP_YDISTANCE,y+152);

   ObjectSetString(0,"EXEC_CURRENCY",OBJPROP_TEXT,AccountInfoString(ACCOUNT_CURRENCY));

   ObjectSetInteger(0,"EXEC_CURRENCY",OBJPROP_COLOR,clrBlack);
   
   //==================================================
   // Execute Button
   //==================================================

   ObjectCreate(0,BTN_EXECUTE,OBJ_BUTTON,0,0,0);

   ObjectSetInteger(0,BTN_EXECUTE,OBJPROP_CORNER,CORNER_RIGHT_UPPER);
   ObjectSetInteger(0,BTN_EXECUTE,OBJPROP_XDISTANCE,x-70);
   ObjectSetInteger(0,BTN_EXECUTE,OBJPROP_YDISTANCE,y+185);

   ObjectSetInteger(0,BTN_EXECUTE,OBJPROP_XSIZE,140);
   ObjectSetInteger(0,BTN_EXECUTE,OBJPROP_YSIZE,28);

   ObjectSetString(0,BTN_EXECUTE,OBJPROP_TEXT,"Execute");

   ObjectSetInteger(0,BTN_EXECUTE,OBJPROP_COLOR,clrBlack);
   ObjectSetInteger(0,BTN_EXECUTE,OBJPROP_BGCOLOR,clrWhite);
   ObjectSetInteger(0,BTN_EXECUTE,OBJPROP_BORDER_COLOR,clrBlack);
   
   return true;
}

//+------------------------------------------------------------------+
//|Update Panel                                                      |
//+------------------------------------------------------------------+
void UpdateExecutionPanel(string fib,
                          double entry,
                          double sl,
                          double tp)
{
   ObjectSetString(0,
                   "EXEC_FIB_VALUE",
                   OBJPROP_TEXT,
                   fib);

   ObjectSetString(0,
                   "EXEC_ENTRY_VALUE",
                   OBJPROP_TEXT,
                   DoubleToString(entry,_Digits));

   ObjectSetString(0,
                   "EXEC_SL_VALUE",
                   OBJPROP_TEXT,
                   DoubleToString(sl,_Digits));

   ObjectSetString(0,
                   "EXEC_TP_VALUE",
                   OBJPROP_TEXT,
                   DoubleToString(tp,_Digits));
}

//+------------------------------------------------------------------+
//| Save Risk Value                                                  |
//+------------------------------------------------------------------+
void SaveRiskValue()
{
   string text = ObjectGetString(0,
                                 EDIT_RISK,
                                 OBJPROP_TEXT);

   double risk = StringToDouble(text);

   if(risk > 0)
      GlobalVariableSet(RISK_GLOBAL,risk);
}

//+------------------------------------------------------------------+
//| Clear Panel                                                      |
//+------------------------------------------------------------------+
void ClearExecutionPanel()
{
   ObjectSetString(0,
                   "EXEC_FIB_VALUE",
                   OBJPROP_TEXT,
                   "");

   ObjectSetString(0,
                   "EXEC_ENTRY_VALUE",
                   OBJPROP_TEXT,
                   "");

   ObjectSetString(0,
                   "EXEC_SL_VALUE",
                   OBJPROP_TEXT,
                   "");

   ObjectSetString(0,
                   "EXEC_TP_VALUE",
                   OBJPROP_TEXT,
                   "");
}

//+------------------------------------------------------------------+
//| Delete Panel                                                     |
//+------------------------------------------------------------------+
void DeleteExecutionPanel()
{
   ObjectDelete(0,PANEL_NAME);

   ObjectDelete(0,"EXEC_TITLE");

   ObjectDelete(0,"EXEC_FIB_LABEL");
   ObjectDelete(0,"EXEC_FIB_VALUE");

   ObjectDelete(0,"EXEC_ENTRY_LABEL");
   ObjectDelete(0,"EXEC_ENTRY_VALUE");

   ObjectDelete(0,"EXEC_SL_LABEL");
   ObjectDelete(0,"EXEC_SL_VALUE");

   ObjectDelete(0,"EXEC_TP_LABEL");
   ObjectDelete(0,"EXEC_TP_VALUE");

   ObjectDelete(0,"EXEC_RISK_LABEL");
   ObjectDelete(0,"EXEC_CURRENCY");

   ObjectDelete(0,EDIT_RISK);

   ObjectDelete(0,BTN_EXECUTE);

   ChartRedraw();
}
#endif