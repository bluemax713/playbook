#!/bin/bash
# Preview the statusline across a spectrum of states — in real color.
# Run:  bash preview.sh
SL="$(cd "$(dirname "$0")" && pwd)/statusline.sh"
dir="$HOME/code/demo-project"        # any path; only the trailing name is shown
NOW=$(date +%s)

# show <ctx%> <cost> <session%> <hours-into-5h> <weekly%> <days-into-week> <label>
show() {
  local fhr=$(( NOW + 18000 - $(awk "BEGIN{print int($4*3600)}") ))
  local sdr=$(( NOW + 604800 - $6 * 86400 ))
  printf "\033[2m── %s ──\033[0m\n" "$7"
  printf '{"model":{"display_name":"Opus 4.8"},"workspace":{"current_dir":"%s"},"context_window":{"used_percentage":%s,"total_input_tokens":%s,"context_window_size":1000000},"cost":{"total_cost_usd":%s},"rate_limits":{"five_hour":{"used_percentage":%s,"resets_at":%s},"seven_day":{"used_percentage":%s,"resets_at":%s}}}' \
    "$dir" "$1" "$(( $1 * 10000 ))" "$2" "$3" "$fhr" "$5" "$sdr" | bash "$SL"
  echo
}

echo
printf "\033[1mClaude Code statusline — gradient bars · pace markers\033[0m\n\n"
#    ctx  cost  sess  h-in  wk  d-in  label
show  5   0.30   8    0.5    2   1   "fresh   · everything early"
show 22   1.20  18    1.0    6   2   "calm    · on pace"
show 42   4.50  33    2.0   14   3   "busy    · slightly ahead"
show 63   8.00  55    3.0   30   4   "warm    · keeping pace"
show 78   9.90  72    3.5   45   5   "toasty  · session running hot"
show 91  11.50  90    4.5   60   6   "hot     · near session reset"
show 99  14.00  97    4.9   80   6   "PANIC   · context nearly full"
show 42 120.00  20    1.5    8   2   "money egg · session cost ≥ \$100"
