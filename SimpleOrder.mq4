//+------------------------------------------------------------------+
//|                                                  SimpleOrder.mq4 |
//|                                             Jordi Mahiques Alamo |
//|                    https://github.com/jmahiques/mt4-simple-order |
//+------------------------------------------------------------------+
#property copyright "Jordi Mahiques Alamo"
#property link      "https://github.com/jmahiques/mt4-simple-order"
#property version   "1.00"
#property strict

#include <SimpleOrder/UserInterface.mqh>
#include <SimpleOrder/OrderExecutionHelper.mqh>

UserInterface *userInterface = new UserInterface();
OrderExecutionHelper *orderExecutionHelper;

//--- input parameters
input double    lotSize=0.01;
input int      stopPips=15;
input int      partialStopPips=12;
input int      profitPits=90;
input int      partialProfitPips=45;
input int      magic_number = 123;
input int      slippage = 5;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   orderExecutionHelper = new OrderExecutionHelper(stopPips, profitPits, partialStopPips, partialProfitPips, lotSize, magic_number, slippage);

   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   delete userInterface;
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   
  }
//+------------------------------------------------------------------+

void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
{
   if (userInterface.isButtonClicked(id, sparam, USER_INTERFACE_MINIMIZE_BUTTON)) {
      Print("Button minimize clicked");
      userInterface.toggleUI();
   } else if(userInterface.isButtonClicked(id, sparam, USER_INTERFACE_BUY_BUTTON)) {
      Print("Button buy clicked");
      orderExecutionHelper.buy();
   } else if(userInterface.isButtonClicked(id, sparam, USER_INTERFACE_SELL_BUTTON)) {
      Print("Button sell clicked");
      orderExecutionHelper.sell();
   }
   userInterface.notifyUserActionEnd();
}
