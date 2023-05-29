/**
 * @file
 * Implements Reversal meta strategy.
 */

// Prevents processing this includes file multiple times.
#ifndef STG_META_REVERSAL_MQH
#define STG_META_REVERSAL_MQH

// User input params.
INPUT2_GROUP("Meta Reversal strategy: main params");
INPUT2 unsigned int Meta_Reversal_Active_Strategies = (1 << 3) + (1 << 4) + (1 << 5) + (1 << 6) + (1 << 8) + (1 << 11) +
                                                   (1 << 15) + (1 << 20) + (1 << 21) + (1 << 22) + (1 << 23) +
                                                   (1 << 24);  // Active strategies
INPUT2_GROUP("Meta Reversal strategy: common params");
INPUT2 float Meta_Reversal_LotSize = 0;                // Lot size
INPUT2 int Meta_Reversal_SignalOpenMethod = 0;         // Signal open method
INPUT2 float Meta_Reversal_SignalOpenLevel = 0;        // Signal open level
INPUT2 int Meta_Reversal_SignalOpenFilterMethod = 32;  // Signal open filter method
INPUT2 int Meta_Reversal_SignalOpenFilterTime = 3;     // Signal open filter time (0-31)
INPUT2 int Meta_Reversal_SignalOpenBoostMethod = 0;    // Signal open boost method
INPUT2 int Meta_Reversal_SignalCloseMethod = 0;        // Signal close method
INPUT2 int Meta_Reversal_SignalCloseFilter = 32;       // Signal close filter (-127-127)
INPUT2 float Meta_Reversal_SignalCloseLevel = 0;       // Signal close level
INPUT2 int Meta_Reversal_PriceStopMethod = 0;          // Price limit method
INPUT2 float Meta_Reversal_PriceStopLevel = 2;         // Price limit level
INPUT2 int Meta_Reversal_TickFilterMethod = 32;        // Tick filter method (0-255)
INPUT2 float Meta_Reversal_MaxSpread = 4.0;            // Max spread to trade (in pips)
INPUT2 short Meta_Reversal_Shift = 0;                  // Shift
INPUT2 float Meta_Reversal_OrderCloseLoss = 80;        // Order close loss
INPUT2 float Meta_Reversal_OrderCloseProfit = 80;      // Order close profit
INPUT2 int Meta_Reversal_OrderCloseTime = -30;         // Order close time in mins (>0) or bars (<0)

// Structs.

// Defines struct with default user strategy values.
struct Stg_Meta_Reversal_Params_Defaults : StgParams {
  Stg_Meta_Reversal_Params_Defaults()
      : StgParams(::Meta_Reversal_SignalOpenMethod, ::Meta_Reversal_SignalOpenFilterMethod, ::Meta_Reversal_SignalOpenLevel,
                  ::Meta_Reversal_SignalOpenBoostMethod, ::Meta_Reversal_SignalCloseMethod, ::Meta_Reversal_SignalCloseFilter,
                  ::Meta_Reversal_SignalCloseLevel, ::Meta_Reversal_PriceStopMethod, ::Meta_Reversal_PriceStopLevel,
                  ::Meta_Reversal_TickFilterMethod, ::Meta_Reversal_MaxSpread, ::Meta_Reversal_Shift) {
    Set(STRAT_PARAM_LS, Meta_Reversal_LotSize);
    Set(STRAT_PARAM_OCL, Meta_Reversal_OrderCloseLoss);
    Set(STRAT_PARAM_OCP, Meta_Reversal_OrderCloseProfit);
    Set(STRAT_PARAM_OCT, Meta_Reversal_OrderCloseTime);
    Set(STRAT_PARAM_SOFT, Meta_Reversal_SignalOpenFilterTime);
  }
};

class Stg_Meta_Reversal : public Strategy {
 protected:
  DictStruct<long, Ref<Strategy>> strats;

 public:
  Stg_Meta_Reversal(StgParams &_sparams, TradeParams &_tparams, ChartParams &_cparams, string _name = "")
      : Strategy(_sparams, _tparams, _cparams, _name) {}

  static Stg_Meta_Reversal *Init(ENUM_TIMEFRAMES _tf = NULL, EA *_ea = NULL) {
    // Initialize strategy initial values.
    Stg_Meta_Reversal_Params_Defaults stg_reversal_defaults;
    StgParams _stg_params(stg_reversal_defaults);
    // Initialize Strategy instance.
    ChartParams _cparams(_tf, _Symbol);
    TradeParams _tparams;
    Strategy *_strat = new Stg_Meta_Reversal(_stg_params, _tparams, _cparams, "(Meta) Reversal");
    return _strat;
  }

  /**
   * Event on strategy's init.
   */
  void OnInit() {}

  /**
   * Sets active strategies.
   */
  bool SetStrategies(EA *_ea = NULL) {
    bool _result = true;
    long _magic_no = Get<long>(STRAT_PARAM_ID);
    ENUM_TIMEFRAMES _tf = Get<ENUM_TIMEFRAMES>(STRAT_PARAM_TF);
    for (int _sid = 0; _sid < sizeof(int) * 8; ++_sid) {
      if ((Meta_Reversal_Active_Strategies & (1 << _sid)) != 0) {
        switch (_sid) {
          case 1 << 0:
            _result &= StrategyAdd<Stg_ADX>(_tf, _magic_no, _sid);
            break;
          case 1 << 1:
            _result &= StrategyAdd<Stg_AMA>(_tf, _magic_no, _sid);
            break;
          case 1 << 2:
            _result &= StrategyAdd<Stg_ASI>(_tf, _magic_no, _sid);
            break;
          case 1 << 3:
            _result &= StrategyAdd<Stg_ATR>(_tf, _magic_no, _sid);
            break;
          case 1 << 4:
            _result &= StrategyAdd<Stg_Alligator>(_tf, _magic_no, _sid);
            break;
          case 1 << 5:
            _result &= StrategyAdd<Stg_Awesome>(_tf, _magic_no, _sid);
            break;
          case 1 << 6:
            _result &= StrategyAdd<Stg_Bands>(_tf, _magic_no, _sid);
            break;
          case 1 << 7:
            _result &= StrategyAdd<Stg_CCI>(_tf, _magic_no, _sid);
            break;
          case 1 << 8:
            _result &= StrategyAdd<Stg_Chaikin>(_tf, _magic_no, _sid);
            break;
          case 1 << 9:
            _result &= StrategyAdd<Stg_DEMA>(_tf, _magic_no, _sid);
            break;
          case 1 << 10:
            _result &= StrategyAdd<Stg_DeMarker>(_tf, _magic_no, _sid);
            break;
          case 1 << 11:
            _result &= StrategyAdd<Stg_Envelopes>(_tf, _magic_no, _sid);
            break;
          case 1 << 12:
            _result &= StrategyAdd<Stg_Gator>(_tf, _magic_no, _sid);
            break;
          case 1 << 13:
            _result &= StrategyAdd<Stg_HeikenAshi>(_tf, _magic_no, _sid);
            break;
          case 1 << 14:
            _result &= StrategyAdd<Stg_Ichimoku>(_tf, _magic_no, _sid);
            break;
          case 1 << 15:
            _result &= StrategyAdd<Stg_Indicator>(_tf, _magic_no, _sid);
            break;
          case 1 << 16:
            _result &= StrategyAdd<Stg_MACD>(_tf, _magic_no, _sid);
            break;
          case 1 << 17:
            _result &= StrategyAdd<Stg_MFI>(_tf, _magic_no, _sid);
            break;
          case 1 << 18:
            _result &= StrategyAdd<Stg_OBV>(_tf, _magic_no, _sid);
            break;
          case 1 << 19:
            _result &= StrategyAdd<Stg_OsMA>(_tf, _magic_no, _sid);
            break;
          case 1 << 20:
            _result &= StrategyAdd<Stg_Pattern>(_tf, _magic_no, _sid);
            break;
          case 1 << 21:
            _result &= StrategyAdd<Stg_Pinbar>(_tf, _magic_no, _sid);
            break;
          case 1 << 22:
            _result &= StrategyAdd<Stg_Pivot>(_tf, _magic_no, _sid);
            break;
          case 1 << 23:
            _result &= StrategyAdd<Stg_RSI>(_tf, _magic_no, _sid);
            break;
          case 1 << 24:
            _result &= StrategyAdd<Stg_RVI>(_tf, _magic_no, _sid);
            break;
          case 1 << 25:
            _result &= StrategyAdd<Stg_SAR>(_tf, _magic_no, _sid);
            break;
          case 1 << 26:
            _result &= StrategyAdd<Stg_StdDev>(_tf, _magic_no, _sid);
            break;
          case 1 << 27:
            _result &= StrategyAdd<Stg_Stochastic>(_tf, _magic_no, _sid);
            break;
          case 1 << 28:
            _result &= StrategyAdd<Stg_WPR>(_tf, _magic_no, _sid);
            break;
          case 1 << 29:
            _result &= StrategyAdd<Stg_ZigZag>(_tf, _magic_no, _sid);
            break;
          case 1 << 30:
            _result &= StrategyAdd<Stg_Momentum>(_tf, _magic_no, _sid);
            break;
          case 1 << 31:
            _result &= StrategyAdd<Stg_MA>(_tf, _magic_no, _sid);
            break;
          default:
            logger.Warning(StringFormat("Unknown strategy: %d", _sid), __FUNCTION_LINE__, GetName());
            break;
        }
      }
    }
    return _result;
  }

  /**
   * Adds strategy to specific timeframe.
   *
   * @param
   *   _tf - timeframe to add the strategy.
   *   _magic_no - unique order identified
   *
   * @return
   *   Returns true if the strategy has been initialized correctly, otherwise false.
   */
  template <typename SClass>
  bool StrategyAdd(ENUM_TIMEFRAMES _tf, long _magic_no = 0, int _type = 0) {
    bool _result = true;
    _magic_no = _magic_no > 0 ? _magic_no : rand();
    Ref<Strategy> _strat = ((SClass *)NULL).Init(_tf);
    _strat.Ptr().Set<long>(STRAT_PARAM_ID, _magic_no);
    _strat.Ptr().Set<ENUM_TIMEFRAMES>(STRAT_PARAM_TF, _tf);
    _strat.Ptr().Set<int>(STRAT_PARAM_TYPE, _type);
    _strat.Ptr().OnInit();
    _result &= strats.Push(_strat);
    return _result;
  }

  /**
   * Check strategy's opening signal.
   */
  bool SignalOpen(ENUM_ORDER_TYPE _cmd, int _method, float _level = 0.0f, int _shift = 0) {
    bool _result = false;
    for (DictStructIterator<long, Ref<Strategy>> iter = strats.Begin(); iter.IsValid() && !_result; ++iter) {
      Strategy *_strat = iter.Value().Ptr();
      _level = _level == 0.0f ? _strat.Get<float>(STRAT_PARAM_SOL) : _level;
      _method = _method == 0 ? _strat.Get<int>(STRAT_PARAM_SOM) : _method;
      _shift = _shift == 0 ? _strat.Get<int>(STRAT_PARAM_SHIFT) : _shift;
      _result |= _strat.SignalOpen(_cmd, _method, _level, _shift);
    }
    return _result;
  }

  /**
   * Check strategy's closing signal.
   */
  bool SignalClose(ENUM_ORDER_TYPE _cmd, int _method, float _level = 0.0f, int _shift = 0) {
    bool _result = false;
    for (DictStructIterator<long, Ref<Strategy>> iter = strats.Begin(); iter.IsValid() && !_result; ++iter) {
      Strategy *_strat = iter.Value().Ptr();
      _level = _level == 0.0f ? _strat.Get<float>(STRAT_PARAM_SCL) : _level;
      _method = _method == 0 ? _strat.Get<int>(STRAT_PARAM_SCM) : _method;
      _shift = _shift == 0 ? _strat.Get<int>(STRAT_PARAM_SHIFT) : _shift;
      _result |= _strat.SignalClose(_cmd, _method, _level, _shift);
    }
    return _result;
  }
};

#endif  // STG_META_REVERSAL_MQH
