---
name: hk-markets
description: |
  Retrieve Hong Kong market data: HSI (恒生指数), HSI futures, HSI options,
  VHSI volatility index, and related China/Hong Kong equity data.
  Use when the user asks about HK stocks, HK futures, Hang Seng Index,
  HSI options, VHSI, or Hong Kong market analysis.
triggers:
  - "港股"
  - "恒生"
  - "香港股市"
  - "HSI"
  - "Hang Seng"
  - "VHSI"
  - "hk markets"
  - "Hong Kong stock"
compatibility: Python 3 with urllib.request (stdlib) — no pip packages needed.
---

# HK Markets — Financial Data Retrieval

## Data Sources

### 1. Yahoo Finance JSON API (preferred)

**恒生指数 (HSI):**
```python
import urllib.request, json
url = "https://query2.finance.yahoo.com/v8/finance/chart/%5EHSI?interval=1d&range=10d"
req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0'})
with urllib.request.urlopen(req, timeout=10) as resp:
    d = json.loads(resp.read())
r = d['chart']['result'][0]
meta = r['meta']
q = r['indicators']['quote'][0]
timestamps = r['timestamp']
```

Key fields from `meta`:
- `regularMarketPrice` — current/last price
- `previousClose` — previous close
- `fiftyTwoWeekHigh` / `fiftyTwoWeekLow`

Key fields from `quote[0]`:
- `close`, `open`, `high`, `low` — per timestamp
- `volume`

Timestamps are Unix epoch seconds — convert with:
```python
from datetime import datetime
dt = datetime.fromtimestamp(timestamp).strftime('%Y-%m-%d')
```

### 2. HSI Intraday (60-minute bars)
```
https://query2.finance.yahoo.com/v8/finance/chart/%5EHSI?interval=60m&range=2d
```
Useful for same-day session analysis.

### 3. Hang Seng China Enterprises (H-shares / 国企指数)
```
https://query2.finance.yahoo.com/v8/finance/chart/%5EHHI?interval=1d&range=10d
```
Note: Yahoo may return 0 for this index — verify `regularMarketPrice > 0`.

### 4. VHSI (Hang Seng Volatility Index)
```
https://query2.finance.yahoo.com/v8/finance/chart/%5EVHSI?interval=1d&range=5d
```
**Currently returns 404 on Yahoo Finance** — VHSI not readily available via Yahoo.

### 5. HSI Futures
Yahoo Finance does **not** carry HSI futures under standard tickers.
Ticker attempts that failed:
- `HSI=F` → 404
- `MESM6` (CME micro) → 404
- `MHI=F` (mini HSI) → 404
- `^VHSI` (options) → 404

For HSI futures, use HKEX direct data or specialized providers.

### 6. HK Open Data API (weather.gov.hk)
For non-market data like surf conditions:
```
# Current weather + forecast
https://data.weather.gov.hk/weatherAPI/opendata/weather.php?dataType=flw&lang=en
# Rainfall, temperature, UV
https://data.weather.gov.hk/weatherAPI/opendata/weather.php?dataType=rhrread&lang=en
```

## Quick-Start Python Snippet

```python
import urllib.request, json
from datetime import datetime

def get_hsi(days=10):
    url = f"https://query2.finance.yahoo.com/v8/finance/chart/%5EHSI?interval=1d&range={days}d"
    req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0'})
    with urllib.request.urlopen(req, timeout=10) as resp:
        d = json.loads(resp.read())
    r = d['chart']['result'][0]
    meta = r['meta']
    q = r['indicators']['quote'][0]
    result = {}
    for i, ts in enumerate(r['timestamp']):
        dt = datetime.fromtimestamp(ts).strftime('%Y-%m-%d')
        result[dt] = {
            'open':  q['open'][i],
            'high':  q['high'][i],
            'low':   q['low'][i],
            'close': q['close'][i],
        }
    return meta, result

meta, bars = get_hsi(5)
print(f"Current: {meta['regularMarketPrice']}")
print(f"52wk high: {meta['fiftyTwoWeekHigh']}, low: {meta['fiftyTwoWeekLow']}")
for dt, b in bars.items():
    print(f"  {dt} C:{b['close']}")
```

### 7. Individual HK Stocks

Yahoo Finance uses `NNNN.HK` format (e.g., `2800.HK`, `3033.HK`).

```python
url = "https://query2.finance.yahoo.com/v8/finance/chart/2800.HK?interval=1d&range=10d"
```

**Caveat**: Yahoo Finance HK stock data is often **1 day stale** — the most recent completed candle may be yesterday, and today's intrasession data (15min bars) reflects partial session. Always check whether the close price matches the known recent date.

### 8. Key HK Index Tickers on Yahoo Finance

| Index | Ticker | Notes |
|-------|--------|-------|
| 恒生指数 | `^HSI` | Main HSI |
| 国企指数 (H股) | `^HHI` | May return 0 — validate price |
| 恒生科技 | `^HSTECH` | Verify ticker availability |
| 盈富基金 | `2800.HK` | Format: `NNNN.HK` |
| 恒生中国企业 | `3033.HK` | Format: `NNNN.HK` |

## Key Limitations

- **Pipe to interpreter blocked**: `curl | python3` triggers security approval.
  Always use `urllib.request` in `execute_code` instead.
- **VHSI unavailable**: No Yahoo Finance ticker for volatility index.
- **HSI futures unavailable**: Yahoo doesn't carry HK futures contracts.
- **HHI may return 0**: Always validate `regularMarketPrice > 0`.
- **Pre-market/gap data**: Check `meta.get('previousClose')` vs `regularMarketPrice`
  to detect gap opens.

## Pitfalls

- **Timestamps are Unix epoch, not local time** — always convert.
- **N/A closes**: Yahoo sometimes returns `null` for close on the most recent bar
  (incomplete candle). Always check `if close is not None`.
- **HTTPS only**: Yahoo enforces HTTPS.
- **User-Agent required**: Omitting the header may result in 403 or redirect loops.
- **HK stock data is 1 day stale**: Yahoo Finance often has no completed candle for
  today. Check the timestamp of the last bar to know what date you're actually looking at.
  Today's intrasession data (15min bars) can give a partial view but the daily candle
  may show yesterday's close.
