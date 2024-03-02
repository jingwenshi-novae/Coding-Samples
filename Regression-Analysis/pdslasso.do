clear
clear matrix
set more off

global myPATH "C:\Users\Jingwen Shi\Desktop\RAs\API_update\god and goddess\"
cd "$myPATH\prelim stata"



// LASSO
use agenreg.dta,clear

/* Agen/Pass: if Agen=1, it's agentic; if Agen=0, it's passive; if Agen=., it means that the API result is "na"*/

lasso logit Agen agri creat art cult disea fate fert hh judg marr natur navi peace trav war wealth wisd handi heal hunt husb prot, rseed(1234)
cvplot
coefpath,legend(on position(12) cols(4))
lassocoef, display(coef)
coefpath, legend(on position(12) cols(4)) xunits(lnlambda) xline(.0004852)

lasso logit Agen (god) agri creat art cult disea fate fert hh judg marr natur navi peace trav war wealth wisd handi heal hunt husb prot, rseed(1234)
cvplot
coefpath,legend(on position(12) cols(4))
lassocoef, display(coef)

lasso probit Agen (god) agri creat art cult disea fate fert hh judg marr natur navi peace trav war wealth wisd handi heal hunt husb prot, rseed(1234)
cvplot
coefpath,legend(on position(12) cols(4))
lassocoef, display(coef)

/* agentic: if agentic=1, it's agentic; if agentic=0, it's passive or "na"*/

lasso logit agentic (god) agri creat art cult disea fate fert hh judg marr natur navi peace trav war wealth wisd handi heal hunt husb prot, rseed(1234)
cvplot
coefpath,legend(on position(12) cols(4))
lassocoef, display(coef)

lasso probit agentic (god) agri creat art cult disea fate fert hh judg marr natur navi peace trav war wealth wisd handi heal hunt husb prot, rseed(1234)
cvplot
coefpath,legend(on position(12) cols(4))
lassocoef, display(coef)


/* passive: if passive=1, it's passive; if passive=0, it's agentic or "na"*/
lasso logit passive agri creat art cult disea fate fert hh judg marr natur navi peace trav war wealth wisd handi heal hunt husb prot, rseed(1234)
cvplot
coefpath,legend(on position(12) cols(4))
lassocoef, display(coef)

lasso logit passive (god) agri creat art cult disea fate fert hh judg marr natur navi peace trav war wealth wisd handi heal hunt husb prot, rseed(1234)
cvplot
coefpath,legend(on position(12) cols(4))
lassocoef, display(coef)

lasso probit passive (god) agri creat art cult disea fate fert hh judg marr natur navi peace trav war wealth wisd handi heal hunt husb prot, rseed(1234)
cvplot
coefpath,legend(on position(12) cols(4))
lassocoef, display(coef)



// pdslasso
use agenreg.dta,clear
ssc install pdslasso, replace

pdslasso Agen god (agri creat art cult disea fate fert hh judg marr natur navi peace trav war wealth wisd handi heal hunt husb prot), robust noisily

pdslasso Agen god (agri creat art cult disea fate fert hh judg marr natur navi peace trav war wealth wisd handi heal hunt husb prot), robust sqrt noisily
