// Include the core files:
#include <nerv/unit/Testing.mqh>
#include <nerv/tests/sanity_specs.mqh>
#include <nerv/tests/math_specs.mqh>
#include <nerv/tests/map_specs.mqh>
#include <nerv/tests/RRLCostFunction_specs.mqh>
#include <nerv/tests/TradeModel_specs.mqh>
#include <nerv/tests/RRLModel_specs.mqh>
#include <nerv/tests/HistoryMap_specs.mqh>
#include <nerv/tests/Strategy_specs.mqh>

BEGIN_TEST_SESSION("RRL_Results")

LOAD_TEST_PACKAGE(sanity_specs)
LOAD_TEST_PACKAGE(math_specs)
LOAD_TEST_PACKAGE(map_specs)
LOAD_TEST_PACKAGE(rrlcostfunction_specs)
LOAD_TEST_PACKAGE(trademodel_specs)
LOAD_TEST_PACKAGE(rrlmodel_specs)
LOAD_TEST_PACKAGE(historymap_specs)
LOAD_TEST_PACKAGE(strategy_specs)

END_TEST_SESSION()