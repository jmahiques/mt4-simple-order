//+------------------------------------------------------------------+
//|                                         OrderExecutionHelper.mqh |
//|                                             Jordi Mahiques Alamo |
//|                    https://github.com/jmahiques/mt4-simple-order |
//+------------------------------------------------------------------+
#property copyright "jordi"
#property link      "https://github.com/jmahiques/mt4-simple-order"
#property version   "1.00"
#property strict

class OrderExecutionHelper
  {
private:
   double stopPips;
   double profitPips;
   double partialStopPips;
   double partialProfitPips;
   double lots;
   int slippage;
   int magicNumber;
   virtual double pipsToPrice(double pips);
public:
                     OrderExecutionHelper(int _stopPips, int _profitPips, int _partialStopPips, int _partialProfitPips, double _lots, int _magicNumber, int _slippage = 5);
                    ~OrderExecutionHelper(){};
   virtual int sell(string comment = "", color arrowColor = clrBlue);
   virtual int buy(string comment = "", color arrowColor = clrBlue);
  };

OrderExecutionHelper::OrderExecutionHelper(int _stopPips, int _profitPips, int _partialStopPips, int _partialProfitPips, double _lots, int _magicNumber, int _slippage = 5)
{
   this.stopPips = _stopPips;
   this.profitPips = _profitPips;
   this.partialStopPips = _partialStopPips;
   this.partialProfitPips = _partialProfitPips;
   this.lots = _lots;
   this.magicNumber = _magicNumber;
   this.slippage = _slippage;
}

int OrderExecutionHelper::sell(string _comment = "", color arrowColor = clrBlue)
{
   const double stop = NormalizeDouble(Ask + this.pipsToPrice(this.stopPips), Digits - 1);
   const double profit = NormalizeDouble(Bid - this.pipsToPrice(this.profitPips), Digits - 1);
   const double partialStop = NormalizeDouble(Ask + this.pipsToPrice(this.partialStopPips), Digits - 1);
   const double partialProfit = NormalizeDouble(Bid - this.pipsToPrice(this.partialProfitPips), Digits - 1);
   
   Print("Opening SELL order SL: ", DoubleToStr(stop), " TP:", DoubleToStr(profit), " at Price: ", DoubleToStr(Bid));
   Print("Opening SELL order PSL: ", DoubleToStr(partialStop), " PTP:", DoubleToStr(partialProfit), " at Price: ", DoubleToStr(Bid));
   
   return 
      OrderSend(Symbol(), OP_SELL, this.lots, Bid, slippage, stop, profit, _comment, this.magicNumber, 0, arrowColor) &&
      OrderSend(Symbol(), OP_SELL, this.lots, Bid, slippage, partialStop, partialProfit, _comment, this.magicNumber, 0, arrowColor);
}

int OrderExecutionHelper::buy(string _comment = "", color arrowColor = clrBlue)
{
   const double stop = NormalizeDouble(Bid - this.pipsToPrice(this.stopPips), Digits - 1);
   const double profit = NormalizeDouble(Ask + this.pipsToPrice(this.profitPips), Digits - 1);
   const double partialStop = NormalizeDouble(Bid - this.pipsToPrice(this.partialStopPips), Digits - 1);
   const double partialProfit = NormalizeDouble(Ask + this.pipsToPrice(this.partialProfitPips), Digits - 1);

   Print("Opening BUY order SL: ", DoubleToStr(stop), " TP:", DoubleToStr(profit), " at Price: ", DoubleToStr(Ask));
   Print("Opening BUY order PSL: ", DoubleToStr(partialStop), " PTP:", DoubleToStr(partialProfit), " at Price: ", DoubleToStr(Ask));
   
   return 
      OrderSend(Symbol(), OP_BUY, this.lots, Ask, slippage, stop, profit, _comment, this.magicNumber, 0, arrowColor) &&
      OrderSend(Symbol(), OP_BUY, this.lots, Ask, slippage, partialStop, partialProfit, _comment, this.magicNumber, 0, arrowColor);
}

double OrderExecutionHelper::pipsToPrice(double pips)
{
   return pips / pow(10, (Digits-1));
}