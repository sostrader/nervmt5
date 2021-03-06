// Include the core files:
#include <nerv/unit/Testing.mqh>
#include <nerv/core.mqh>
#include <nerv/trading/PatternTrader.mqh>

void OnStart()
{
  nvLogManager* lm = nvLogManager::instance();
  string fname = "test_pattern_trader.log";
  nvFileLogger* logger = new nvFileLogger(fname);
  lm.addSink(logger);

  logDEBUG("Initializing PatternTrader test");

  string filename = "EURUSD_tick_2015_01.csv";

  int handle = FileOpen(filename, FILE_READ | FILE_ANSI | FILE_TXT);
  // int numTicks = 30000+30+1+10+20;
  // int numTicks = 60000+30+1+10+20;
  int numTicks = 400000+30+1+10+20;
  // int numTicks = 120000+30+1+10+20;
  string sep = ",";
  ushort u_sep = StringGetCharacter(sep,0);


  nvPatternTrader* trader = new nvPatternTrader("EURUSD",true,1);
  trader.setVariationLevel(20.0);
  // trader.setVariationLevel(20.0);
  // trader.setVariationLevel(15.0);
  
  // First we try with no spread at all:
  trader.setMeanSpread(0.0001);
  // trader.setGainTarget(0.00015);
  trader.setGainTarget(0.0001);

  trader.setPatternLength(40);
  trader.setPredictionOffset(20);
  trader.setPredictionLength(10);
  trader.setMaxPatternCount(10000);
  trader.setMinPatternCount(10000);

  double bid,ask;
  string line;
  string elems[];

  datetime startTime = TimeLocal();

  for(int i=0; i<numTicks; ++i)
  {
    line = FileReadString(handle);
    // logDEBUG("Read line: "<<line);

    int len = StringSplit(line,u_sep,elems); 
    CHECK(len==5,"Invalid number of elements!");

    // We only keep the time tag and the prediction:
    bid = StringToDouble(elems[1]);
    ask = StringToDouble(elems[2]);

    // convert the time string to time value:
    // "2015.01.01 22:04:23.564"

    // logDEBUG("Substr 1 is: "<< StringSubstr(elems[0],0,16))
    
    datetime ctime = StringToTime(StringSubstr(elems[0],0,16));
    int secs = (int)(StringToDouble(StringSubstr(elems[0],17,6))+0.5); 

    ctime += secs;
    // logDEBUG("Detected time: "<< ctime)

    trader.addInput((bid+ask)*0.5,ctime);
    if(i%200==0)
    {
      logDEBUG("Done "<<StringFormat("%.2f%%",100.0*(double)i/(double)numTicks));
    }
  }

  datetime endTime = TimeLocal();

  RELEASE_PTR(trader);

  logDEBUG("Done executing PatternTrader test in "<<(int)(endTime-startTime)<<" seconds.");
}
