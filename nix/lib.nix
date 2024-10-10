{ lib, ... }:
let
  toPrettyString =
    x:
    if builtins.isNull x then
      "null"
    else if builtins.isString x then
      ''"${lib.escape [ "\"" ] x}"''
    else if builtins.isBool x then
      if x then "true" else "false"
    else if lib.isDerivation x then
      # if x ? outPath then "«derivation ${x.outPath}»" else "«derivation»"
      if x ? drvPath then "«derivation ${x.drvPath}»" else "«derivation»"
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

  prettyTrace = desc: x: builtins.trace "${desc}:\t\t${toPrettyString x}";
  prettyTraceId = desc: x: prettyTrace desc x x;

  # prettyTraceDebug = prettyTrace;
  prettyTraceDebug =
    x: y: z:
    z;
  # prettyTraceIdDebug = prettyTraceId;
  prettyTraceIdDebug = x: y: y;
in

{
  inherit
    toPrettyString
    prettyTrace
    prettyTraceId
    prettyTraceDebug
    prettyTraceIdDebug
    ;
}
