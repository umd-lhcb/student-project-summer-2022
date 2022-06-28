final: prev:

{
  pythonOverrides = finalPy: prevPy: {
    mplhep = finalPy.callPackage ./mplhep { };
    uhi = finalPy.callPackage ./uhi { };
  };
  python3 = prev.python3.override { packageOverrides = final.pythonOverrides; };
}
