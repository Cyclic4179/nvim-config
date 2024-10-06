{ lib, ... }:
let
  toPrettyString =
    x:
    if builtins.isNull x then
      "null"
    else if builtins.isString x then
      ''"${lib.escape [ "\"" ] x}"''
    else if builtins.isBool x then
      if x then "true" else false
    else if
      builtins.isInt x || builtins.isFloat x || builtins.isPath x || x ? outPath || x ? __toString
    then
      toString x
    else if builtins.isList x then
      "[ ${builtins.foldl' (acc: v: acc + toPrettyString v + " ") "" x}]"
    else if builtins.isAttrs x then
      "{ ${
        builtins.foldl' (acc: v: acc + "${v} = ${toPrettyString x.${v}}; ") "" (builtins.attrNames x)
      }}"
    else
      "«lambda»";

  prettyTrace = x: builtins.trace (toPrettyString x);
  prettyTraceId = x: prettyTrace x x;
in
{
  inherit toPrettyString prettyTrace prettyTraceId;
}
