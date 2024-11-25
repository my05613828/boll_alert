各个周期的布林上下轨穿越警报该如何编写

布林带指标是众多交易爱好者非常喜欢的指标；

由于外汇黄金交易的时间很长，我们不可能实时盯盘，经常由于错过信号而错过赚钱机会，那么有一款能够检测并发出警报的程序就很有必要了。

mt5 提供的周期众多列入M1 M2 M3 M4 H1,H2,H6等比mt4多出不少，那我们如何编写优雅的警报代码呢！下面请听我徐徐道来：

首先

我们准备个数组 用于存储各个图表周期 各个数组名_chart_period[]

ENUM_TIMEFRAMES//数据类型 _chart_period[]= {PERIOD_M1,PERIOD_M2,PERIOD_M3,PERIOD_M4,PERIOD_M5,PERIOD_M6,PERIOD_M10,PERIOD_M12,PERIOD_M15,   PERIOD_M30,PERIOD_H1,PERIOD_H2,PERIOD_H2,PERIOD_H3,PERIOD_H4,PERIOD_H6,PERIOD_H8,PERIOD_H12,PERIOD_D1  };

然后 我们声明一个类 

在类里面声明必要的bands(布林带)指标参数，和存储布林带上下轨值的数组

在声明一个 working 函数用于判断值和发出警报

1.for 图表周期

2.调用指标赋值给句柄

3.操控句柄拷贝到数组

4.数组进行k线穿越判断

5.发出警报(设置警报间隔秒数

具体可以参考下文

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

//有参构造

     {

      bands_period=bands_periods;

      dev=devs;

     }

                    ~bands(){};

  };

//+------------------------------------------------------------------void bands::working()

  {

   int len = ArraySize(_chart_period);//获取图表周期长度

   for(int i=0;i<len;i++)

     {

      bands_h=iBands(Symbol(),_chart_period[i],bands_period,0,dev,PRICE_CLOSE);//获取句柄

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

最后   就是调用了  我们需要准备个EA模版

1.引入类

2.创造类对象

3.调用工作函数



//+------------------------------------------------------------------+

//|                                                   boll_alert.mq5 |



#include "bands.mqh"//引入类

input int _boll_period = 14;//布林周期

input double _devs = 2.0;//布林偏差

bands bd(_boll_period,_devs);//有参构造类对象

int OnInit()

  {

//--- create timer

   EventSetTimer(60);

   

//---

   return(INIT_SUCCEEDED);

  }

//+------------------------------------------------------------------+

//| Expert deinitialization function                                 |

//+------------------------------------------------------------------+

void OnDeinit(const int reason)

  {

//--- destroy timer

   EventKillTimer();

   

  }

//+------------------------------------------------------------------+

//| Expert tick function                                             |

//+------------------------------------------------------------------+

void OnTick()

  {

//---

   bd.working();//调用工作函数

  }

//+------------------------------------------------------------------

