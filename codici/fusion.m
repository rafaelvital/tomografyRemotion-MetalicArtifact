function F = fusion(Iprec,Iunc,t,n)
% [F] = fusion(Iprec,Iunc,t,n)
% Fa la fusione della imagine Iprec con la Iunc con i parametri t e n.  

  D = Iprec-Iunc;
  dmim = min(min(D));
  dmax = max(max(D));
  Dnorm = (D-dmim)/(dmax-dmim);
  W = 1./(1+(Dnorm/t).^n);
  F = W.*Iunc+(1-W).*Iprec;
end