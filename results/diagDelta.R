# diagnose delta
# by Simon Schwab
library(DGM)

PATH_NET = '~/Drive/DGM_rois104'
INFO     = 'Nn66'
N=30
Nn=66

f = list.files(path=PATH_NET, pattern=sprintf('_%s_', INFO))
EIDS = substring(f, 1, 7)

delta = array(NA, dim=c(N,Nn))

for (s in 1:N) {
  print(sprintf("Loading Subject %03d", s))
  delta[s,] = diag.delta(path=PATH_NET, id=sprintf("%s_Nn66", EIDS[s]), nodes = Nn)
}

sum(delta < 1)/length(delta)

# with 66 nodes 27% is below 1 and 4.5% below 0.99