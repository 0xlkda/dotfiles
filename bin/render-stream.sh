#!/usr/bin/env bash
# Renders claude stream-json output as a human-readable stream.
# Usage: claude -p "prompt" --output-format stream-json --verbose | ./render-stream.sh

jq -rj --unbuffered '
  def dim: "\u001b[2m";
  def reset: "\u001b[0m";
  def bold_blue: "\u001b[1;34m";
  def trunc(n): if length > n then .[:n] + "…" else . end;
  def fmt_duration:
    if . >= 1000 then (. / 100 | round / 10 | tostring) + "s"
    else (. | tostring) + "ms"
    end;

  if .type == "system" and .subtype == "init" then
    dim + "── " + (.model // "unknown") +
    (if .permissionMode then " · " + .permissionMode + " mode" else "" end) +
    " ──" + reset + "\n"

  elif .type == "assistant" then
    (.message.content // [])[] |
    if .type == "text" then
      (if .text[:1] != "\n" then "\n" else "" end) + .text + (if .text[-1:] != "\n" then "\n" else "" end)
    elif .type == "tool_use" then
      (.name) as $tool |
      # Primary param
      (
        if   $tool == "Read"      then .input.file_path
        elif $tool == "Glob"      then .input.pattern
        elif $tool == "Grep"      then .input.pattern
        elif $tool == "Edit"      then .input.file_path
        elif $tool == "Write"     then .input.file_path
        elif $tool == "Bash"      then (.input.command | trunc(80))
        elif $tool == "WebFetch"  then .input.url
        elif $tool == "WebSearch" then .input.query
        elif $tool == "Task"      then .input.description
        elif ($tool | startswith("mcp__db__")) then (.input.sql | trunc(80))
        else ([.input | to_entries[] | select(.value | type == "string") | .value] | first // null)
        end
      ) as $param |
      # Secondary info
      (
        if $tool == "Read" then
          [if .input.offset then "offset " + (.input.offset | tostring) else empty end,
           if .input.limit  then "limit "  + (.input.limit  | tostring) else empty end]
          | if length > 0 then join(", ") else null end
        elif $tool == "Glob" then
          .input.path // null
        elif $tool == "Grep" then
          [if .input.path then .input.path else empty end,
           if .input.glob then .input.glob else empty end,
           if .input.type then .input.type else empty end]
          | if length > 0 then join(", ") else null end
        elif $tool == "Edit" then
          if .input.old_string then (.input.old_string | trunc(60)) else null end
        elif $tool == "Bash" then
          if .input.description then "# " + .input.description else null end
        elif $tool == "Task" then
          .input.subagent_type // null
        else null
        end
      ) as $extra |
      "\n" + bold_blue + "🔧 " + $tool + " " + reset +
      (if $param then dim + $param + reset else "" end) +
      (if $extra then "  " + dim + $extra + reset else "" end) +
      "\n"
    else
      empty
    end

  elif .type == "user" and .tool_use_result then
    .tool_use_result as $tr |
    (.message.content[0].content // "") as $raw |
    if ($tr | type) == "string" then
      "   " + dim + "↳ " + $tr + reset + "\n"
    else
      (
        [
          if $tr.durationMs then ($tr.durationMs | fmt_duration) else empty end,
          if $tr.numFiles   then ($tr.numFiles | tostring) + " files" else empty end,
          if $tr.numLines   then ($tr.numLines | tostring) + " lines" else empty end,
          if $tr.truncated == true then "truncated" else empty end
        ] | if length > 0 then join(" · ") else null end
      ) as $meta |
      (if $meta then "   " + dim + "↳ " + $meta + reset + "\n" else "" end) +
      # Detail: file list or content preview (max 8 lines, 120 chars)
      (if $tr.filenames and ($tr.filenames | length) > 0 then
        ($tr.filenames | .[0:8] | map("   " + dim + "  " + . + reset) | join("\n")) +
        (if ($tr.filenames | length) > 8 then "\n   " + dim + "  …" + reset else "" end) + "\n"
      elif (($tr.content // $raw) | length) > 0 then
        (($tr.content // $raw) | split("\n") | map(select(length > 0)) | .[0:8]) as $lines |
        ($lines | map("   " + dim + "│ " + (if length > 120 then .[:120] + "…" else . end) + reset) | join("\n")) +
        (if (($tr.content // $raw) | split("\n") | map(select(length > 0)) | length) > 8 then
          "\n   " + dim + "│ …" + reset
        else "" end) + "\n"
      else "" end)
    end

  elif .type == "result" then
    "\n" + dim + "── result: " +
    (if .cost_usd then "cost $" + (.cost_usd | tostring) else "" end) +
    (if .num_turns then "  turns " + (.num_turns | tostring) else "" end) +
    (if .duration_ms then "  duration " + ((.duration_ms / 1000 * 10 | round / 10) | tostring) + "s" else "" end) +
    " ──" + reset + "\n"
  else
    empty
  end
'
