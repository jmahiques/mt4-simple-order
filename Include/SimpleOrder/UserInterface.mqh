//+------------------------------------------------------------------+
//|                                                UserInterface.mqh |
//|                                             Jordi Mahiques Alamo |
//|                    https://github.com/jmahiques/mt4-simple-order |
//+------------------------------------------------------------------+
#property copyright "Jordi Mahiques Alamo"
#property link      "https://github.com/jmahiques/mt4-simple-order"
#property strict

const string USER_INTERFACE_MINIMIZE_BUTTON = "USER_INTERFACE_MINIMIZE_BUTTON";
const string USER_INTERFACE_BUY_BUTTON = "USER_INTERFACE_BUY_BUTTON";
const string USER_INTERFACE_SELL_BUTTON = "USER_INTERFACE_SELL_BUTTON";
const string USER_INTERFACE_CLOSE_ALL_BUTTON = "USER_INTERFACE_CLOSE_ALL_BUTTON";

class UserInterface
  {
private:
   long chartId;
   bool hiddenUI;
   
   virtual void drawButton(string buttonName, int x, int y, int width, int height,
      color buttonBackground, color buttonColor, string buttonText);
   virtual void destroyUI();
   virtual void hideUI();
   virtual void showUI();
public:
                     UserInterface();
                    ~UserInterface();
   virtual bool isButtonClicked(const int id,const string &sparam, string buttonName);
   virtual void notifyUserActionEnd();
   virtual void toggleUI();
  };
  
UserInterface::UserInterface()
{
   this.chartId = ChartID();
   this.hiddenUI = false;

   this.drawButton(USER_INTERFACE_MINIMIZE_BUTTON, 10, 20, 80, 20, clrDarkGray, clrBlack, "-");
   this.drawButton(USER_INTERFACE_BUY_BUTTON, 10, 45, 80, 20, clrOliveDrab, clrWhite, "BUY");
   this.drawButton(USER_INTERFACE_SELL_BUTTON, 10, 70, 80, 20, clrRed, clrWhite, "SELL");
   //this.drawButton(USER_INTERFACE_CLOSE_ALL_BUTTON, 10, 95, 80, 20, clrDarkGray, clrWhite, "CLOSE ALL");
}

UserInterface::~UserInterface()
{
   this.destroyUI();
}

void UserInterface::drawButton(const string buttonName, int x, int y, int width, int height, color buttonBackground, color buttonColor, string buttonText)
{
   if(!ObjectCreate(this.chartId, buttonName, OBJ_BUTTON, 0, 0, 0)) {
      Print("Error at function ", __FUNCTION__, " while drawing a button with name ", buttonName, ". Error code: ", GetLastError());
   }
   ObjectSetInteger(this.chartId, buttonName, OBJPROP_XDISTANCE, x);
   ObjectSetInteger(this.chartId, buttonName, OBJPROP_YDISTANCE, y);
   ObjectSetInteger(this.chartId, buttonName, OBJPROP_XSIZE, width);
   ObjectSetInteger(this.chartId, buttonName, OBJPROP_YSIZE, height);
   ObjectSetInteger(this.chartId, buttonName, OBJPROP_BGCOLOR, buttonBackground);
   ObjectSetInteger(this.chartId, buttonName, OBJPROP_COLOR, buttonColor);
   ObjectSetString(this.chartId, buttonName, OBJPROP_TEXT, buttonText);
}

void UserInterface::destroyUI()
{
   ObjectDelete(this.chartId, USER_INTERFACE_MINIMIZE_BUTTON);
   ObjectDelete(this.chartId, USER_INTERFACE_BUY_BUTTON);
   ObjectDelete(this.chartId, USER_INTERFACE_SELL_BUTTON);
   //ObjectDelete(this.chartId, USER_INTERFACE_CLOSE_ALL_BUTTON);
}

void UserInterface::notifyUserActionEnd(void)
{
   ObjectSetInteger(this.chartId, USER_INTERFACE_MINIMIZE_BUTTON, OBJPROP_STATE, 0);
   ObjectSetInteger(this.chartId, USER_INTERFACE_BUY_BUTTON, OBJPROP_STATE, 0);
   ObjectSetInteger(this.chartId, USER_INTERFACE_SELL_BUTTON, OBJPROP_STATE, 0);
   ObjectSetInteger(this.chartId, USER_INTERFACE_CLOSE_ALL_BUTTON, OBJPROP_STATE, 0);
}

bool UserInterface::isButtonClicked(const int id, const string &sparam, const string buttonName)
{
   return id == CHARTEVENT_OBJECT_CLICK &&
          sparam == buttonName &&
          ObjectGetInteger(0,buttonName,OBJPROP_STATE) == 1;
}

void UserInterface::toggleUI(void)
{
   if (this.hiddenUI) {
      this.hiddenUI = false;
      this.showUI();
      return;
   }
   
   this.hideUI();
   this.hiddenUI = true;
}

void UserInterface::hideUI(void)
{
   ObjectDelete(this.chartId, USER_INTERFACE_BUY_BUTTON);
   ObjectDelete(this.chartId, USER_INTERFACE_SELL_BUTTON);
   //ObjectDelete(this.chartId, USER_INTERFACE_CLOSE_ALL_BUTTON);
}

void UserInterface::showUI(void)
{
   this.drawButton(USER_INTERFACE_BUY_BUTTON, 10, 45, 80, 20, clrOliveDrab, clrWhite, "BUY");
   this.drawButton(USER_INTERFACE_SELL_BUTTON, 10, 70, 80, 20, clrRed, clrWhite, "SELL");
   //this.drawButton(USER_INTERFACE_CLOSE_ALL_BUTTON, 10, 95, 80, 20, clrDarkGray, clrWhite, "CLOSE ALL");
}