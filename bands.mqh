//+------------------------------------------------------------------+
//|                                                        bands.mqh |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"

#include <M5/指标类.mqh>
指标类 指标;
#include <M5/交易类.mqh>
交易类 交易;
ENUM_TIMEFRAMES     _chart_period[]= {PERIOD_M1,PERIOD_M2,PERIOD_M3,PERIOD_M4,PERIOD_M5,PERIOD_M6,PERIOD_M10,PERIOD_M12,PERIOD_M15,
                                      PERIOD_M30,PERIOD_H1,PERIOD_H2,PERIOD_H3,PERIOD_H4,PERIOD_H6,PERIOD_H8,PERIOD_H12,PERIOD_D1
                                     };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class bands
  {
private:
   int               bands_h;//句柄
   int               bands_period;//布林周期
   double            dev;//偏差
   double            bands_mean[],bands_up[],bands_down[];//中上和下值数组

public:
   void              working();//工作函数

                     bands(int bands_periods=14,double devs=2)
     {
      bands_period=bands_periods;
      dev=devs;
     }
                    ~bands();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bands::~bands()
  {
  }
//+------------------------------------------------------------------+
void bands::working()
  {
   int len = ArraySize(_chart_period);
   for(int i=0;i<len;i++)
     {
      bands_h=iBands(Symbol(),_chart_period[i],bands_period,0,dev,PRICE_CLOSE);
      指标.句柄至数组(bands_h,bands_mean,bands_up,bands_down,0,5);

      bool k_up = 交易.K线穿越某值(Symbol(),_chart_period[i],1,3,0,bands_up[1],bands_up[0]);
      bool K_down = 交易.K线穿越某值(Symbol(),_chart_period[i],2,3,0,bands_down[1],bands_down[0]);

      if(k_up&&交易.单位时间do1(30))
        {
         Alert(Symbol()+" "+EnumToString(_chart_period[i])+" 向  上上上  穿越布林带上轨了");
        }
      if(K_down&&交易.单位时间do2(30))
        {
         Alert(Symbol()+" "+EnumToString(_chart_period[i])+" 向 下下下  穿越布林带下轨了");
        }
     }
  }
//+------------------------------------------------------------------+
