//
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2021-2022 - UTC - Stéphane MOTTELET
//
// This file is hereby licensed under the terms of the GNU GPL v3.0,
// For more information, see the COPYING file which you should have received
//
//--------------------------------------------------------------------------

#ifndef _ARKODEMANAGER_HXX_
#define _ARKODEMANAGER_HXX_

#include "dynlib_differential_equations.h"

#include "OdeManager.hxx"

#include <arkode/arkode_impl.h>
#include <arkode/arkode_ls_impl.h>
#include <arkode/arkode.h>            /* prototypes for ARKODES fcts. and consts. */
#include <arkode/arkode_butcher_erk.h>
#include <arkode/arkode_butcher_dirk.h>
#include <arkode/arkode_arkstep.h>
#include <arkode/arkode_bandpre.h>

extern "C"
{
    int ARKStepSetMaxOrd(void *, int);
}

typedef void(*dynlibFunPtr)();

class DIFFERENTIAL_EQUATIONS_IMPEXP ARKODEManager final : public OdeManager
{
public :

    ARKODEManager()
    {
        m_strSolver = "arkode";
        m_wstrSolver = L"arkode";
        // construct map of methods
        for (const auto &it : vectARKODEMethods)
        {
            ARKODEMethods[it.first]=it.second;
        }
        setUserData = ARKStepSetUserData;
        setInitStep = ARKStepSetInitStep;
        setMinStep = ARKStepSetMinStep;
        setMaxStep = ARKStepSetMaxStep;
        setMaxNumSteps = ARKStepSetMaxNumSteps;
        setStopTime = ARKStepSetStopTime;
        setMaxOrd = ARKStepSetMaxOrd;
        getCurrentTime = ARKStepGetCurrentTime;
        getCurrentStep = ARKStepGetCurrentStep;
        getLastStep = ARKStepGetLastStep;
        getRootInfo = ARKStepGetRootInfo;
        setConstraints = ARKStepSetConstraints;
        setVTolerances = ARKStepSVtolerances;
        setErrHandlerFn = ARKStepSetErrHandlerFn;
        getReturnFlagName = ARKStepGetReturnFlagName;
        getDky = ARKStepGetDky;

        toODEReturn.emplace(ARK_SUCCESS, ODE_SUCCESS);
        toODEReturn.emplace(ARK_TSTOP_RETURN, ODE_TSTOP_RETURN);
        toODEReturn.emplace(ARK_ROOT_RETURN, ODE_ROOT_RETURN);
        toODEReturn.emplace(ARK_CONV_FAILURE, ODE_CONV_FAILURE);
        toODEReturn.emplace(ARK_TOO_MUCH_WORK, ODE_TOO_MUCH_WORK);
        toODEReturn.emplace(ARK_REPTD_RHSFUNC_ERR, ODE_REPTD_RHSFUNC_ERR);
        toODEReturn.emplace(ARK_WARNING, ODE_WARNING);

        fromODEReturn.emplace(ODE_SUCCESS, ARK_SUCCESS);
        fromODEReturn.emplace(ODE_TSTOP_RETURN, ARK_TSTOP_RETURN );
        fromODEReturn.emplace(ODE_ROOT_RETURN, ARK_ROOT_RETURN);
        fromODEReturn.emplace(ODE_CONV_FAILURE, ARK_CONV_FAILURE);
        fromODEReturn.emplace(ODE_TOO_MUCH_WORK, ARK_TOO_MUCH_WORK);
        fromODEReturn.emplace(ODE_REPTD_RHSFUNC_ERR, ARK_REPTD_RHSFUNC_ERR);
        fromODEReturn.emplace(ODE_WARNING, ARK_WARNING);
    }

    ~ARKODEManager()
    {
        if (m_prob_mem != NULL)
        {
            ARKStepFree(&m_prob_mem);
        }
        m_prob_mem = NULL;
    };

    void setPreviousManager(void *p)
    {
        m_prevManager = static_cast<ARKODEManager *>(p);
        m_odeIsExtension = true;
    }

    OdeManager *getPreviousManager()
    {
        return m_prevManager;
    }

    virtual bool isODE()
    {
        return true;
    }

    std::wstring getInterpolationMethod()
    {
        std::wstringstream wstr;
        wstr << m_wstrInterpolationMethod << L"(" << m_iInterpolationDegree << L")";
        return wstr.str();
    }

    int getBasisDimensionAtIndex(int iIndex);
    double *getBasisAtIndex(int iIndex);

    void parseMethodAndOrder(types::optional_list &opt);
    bool create();
    std::wstring getDefaultNonLinSolver();
    std::vector<std::wstring> getAvailableNonLinSolvers();
    bool initialize(char *);
    // void errHandler(int error_code, const char *module, const char *function, char *msg);
    bool setEventFunction();
    bool setSolverAndJacobian(char *errorMsg);
    int getInterpBasisSize();
    solverReturnCode doStep(double dblFinalTime, double *pdblTime, solverTaskCode iKind);
    void saveInterpBasisVectors();
    void getInterpVectors(double *pdblNS, int iOrderPlusOne, int iIndex, double dblt0, double dblTUser, double dblStep, double *pdblVect, double *pdblVectd);
    void getButcherTabInPlist(types::optional_list &opt, const wchar_t * _pwstLabel, ARKodeButcherTable &ButcherTab);

    int DQJtimes(realtype tt, N_Vector yy, N_Vector yp, N_Vector rr,
                      N_Vector v, N_Vector Jv, realtype c_j,
                      N_Vector work2, N_Vector work3) final;

    types::Struct *getStats();

    typedef struct {
        ARKODE_ERKTableID erkID;
        ARKODE_DIRKTableID dirkID;
        int order;
        int embeddedOrder;
    } methodInfo;

    std::map<std::wstring,methodInfo> ARKODEMethods;

    std::vector<std::pair<std::wstring, methodInfo>> vectARKODEMethods =
    {
        // explicit methods
        {L"ERK",{ARKODE_ZONNEVELD_5_3_4,ARKODE_DIRK_NONE,4,3}},
        {L"ERK_2",{ARKODE_HEUN_EULER_2_1_2,ARKODE_DIRK_NONE,2,1}},
        {L"ERK_3",{ARKODE_BOGACKI_SHAMPINE_4_2_3,ARKODE_DIRK_NONE,3,2}},
        {L"ERK_4",{ARKODE_ZONNEVELD_5_3_4,ARKODE_DIRK_NONE,4,3}},
        {L"ERK_5",{ARKODE_CASH_KARP_6_4_5,ARKODE_DIRK_NONE,5,4}},
        {L"ERK_6",{ARKODE_VERNER_8_5_6,ARKODE_DIRK_NONE,6,5}},
        {L"ERK_8",{ARKODE_FEHLBERG_13_7_8,ARKODE_DIRK_NONE,8,7}},
        {L"HEUN_EULER_2_1_2",{ARKODE_HEUN_EULER_2_1_2,ARKODE_DIRK_NONE,2,1}},
        {L"BOGACKI_SHAMPINE_4_2_3",{ARKODE_BOGACKI_SHAMPINE_4_2_3,ARKODE_DIRK_NONE,3,2}},
        {L"ARK324L2SA_ERK_4_2_3",{ARKODE_ARK324L2SA_ERK_4_2_3,ARKODE_DIRK_NONE,3,2}},
        {L"ZONNEVELD_5_3_4",{ARKODE_ZONNEVELD_5_3_4,ARKODE_DIRK_NONE,4,3}},
        {L"ARK436L2SA_ERK_6_3_4",{ARKODE_ARK436L2SA_ERK_6_3_4,ARKODE_DIRK_NONE,4,3}},
        {L"SAYFY_ABURUB_6_3_4",{ARKODE_SAYFY_ABURUB_6_3_4,ARKODE_DIRK_NONE,4,3}},
        {L"CASH_KARP_6_4_5",{ARKODE_CASH_KARP_6_4_5,ARKODE_DIRK_NONE,5,4}},
        {L"FEHLBERG_6_4_5",{ARKODE_FEHLBERG_6_4_5,ARKODE_DIRK_NONE,5,4}},
        {L"ARK548L2SA_ERK_8_4_5",{ARKODE_ARK548L2SA_ERK_8_4_5,ARKODE_DIRK_NONE,5,4}},
        {L"VERNER_8_5_6",{ARKODE_VERNER_8_5_6,ARKODE_DIRK_NONE,6,5}},
        {L"FEHLBERG_13_7_8",{ARKODE_FEHLBERG_13_7_8,ARKODE_DIRK_NONE,8,7}},
        //{L"KNOTH_WOLKE_3_3",{{ARKODE_KNOTH_WOLKE_3_3,ARKODE_DIRK_NONE,3}}},
        {L"ARK437L2SA_ERK_7_3_4",{ARKODE_ARK437L2SA_ERK_7_3_4,ARKODE_DIRK_NONE,4,3}},
        {L"ARK548L2SAb_ERK_8_4_5",{ARKODE_ARK548L2SAb_ERK_8_4_5,ARKODE_DIRK_NONE,5,4}},

        // implicit methods
        {L"DIRK",{ARKODE_ERK_NONE,ARKODE_SDIRK_5_3_4,4,3}},
        {L"DIRK_2",{ARKODE_ERK_NONE,ARKODE_SDIRK_2_1_2,2,1}},
        {L"DIRK_3",{ARKODE_ERK_NONE,ARKODE_ARK324L2SA_DIRK_4_2_3,3,3}},
        {L"DIRK_4",{ARKODE_ERK_NONE,ARKODE_SDIRK_5_3_4,4,3}},
        {L"DIRK_5",{ARKODE_ERK_NONE,ARKODE_ARK548L2SA_DIRK_8_4_5,5,4}},
        {L"SDIRK_2_1_2",{ARKODE_ERK_NONE,ARKODE_SDIRK_2_1_2,2,1}},
        {L"BILLINGTON_3_3_2",{ARKODE_ERK_NONE,ARKODE_BILLINGTON_3_3_2,2,3}},
        {L"TRBDF2_3_3_2",{ARKODE_ERK_NONE,ARKODE_TRBDF2_3_3_2,2,3}},
        {L"KVAERNO_4_2_3",{ARKODE_ERK_NONE,ARKODE_KVAERNO_4_2_3,3,2}},
        {L"ARK324L2SA_DIRK_4_2_3",{ARKODE_ERK_NONE,ARKODE_ARK324L2SA_DIRK_4_2_3,3,2}},
        {L"CASH_5_2_4",{ARKODE_ERK_NONE,ARKODE_CASH_5_2_4,4,2}},
        {L"CASH_5_3_4",{ARKODE_ERK_NONE,ARKODE_CASH_5_3_4,4,3}},
        {L"SDIRK_5_3_4",{ARKODE_ERK_NONE,ARKODE_SDIRK_5_3_4,4,3}},
        {L"KVAERNO_5_3_4",{ARKODE_ERK_NONE,ARKODE_KVAERNO_5_3_4,4,3}},
        {L"ARK436L2SA_DIRK_6_3_4",{ARKODE_ERK_NONE,ARKODE_ARK436L2SA_DIRK_6_3_4,4,3}},
        {L"KVAERNO_7_4_5",{ARKODE_ERK_NONE,ARKODE_KVAERNO_7_4_5,5,4}},
        {L"ARK548L2SA_DIRK_8_4_5",{ARKODE_ERK_NONE,ARKODE_ARK548L2SA_DIRK_8_4_5,5,4}},
        {L"ARK437L2SA_DIRK_7_3_4",{ARKODE_ERK_NONE,ARKODE_ARK437L2SA_DIRK_7_3_4,4,3}},
        {L"ARK548L2SAb_DIRK_8_4_5",{ARKODE_ERK_NONE,ARKODE_ARK548L2SAb_DIRK_8_4_5,5,4}},
        {L"ESDIRK324L2SA_4_2_3",{ARKODE_ERK_NONE,ARKODE_ESDIRK324L2SA_4_2_3,3,2}},
        {L"ESDIRK325L2SA_5_2_3",{ARKODE_ERK_NONE,ARKODE_ESDIRK325L2SA_5_2_3,3,2}},
        {L"ESDIRK32I5L2SA_5_2_3",{ARKODE_ERK_NONE,ARKODE_ESDIRK32I5L2SA_5_2_3,3,2}},
        {L"ESDIRK436L2SA_6_3_4",{ARKODE_ERK_NONE,ARKODE_ESDIRK436L2SA_6_3_4,4,3}},
        {L"ESDIRK43I6L2SA_6_3_4",{ARKODE_ERK_NONE,ARKODE_ESDIRK43I6L2SA_6_3_4,4,3}},
        {L"QESDIRK436L2SA_6_3_4",{ARKODE_ERK_NONE,ARKODE_QESDIRK436L2SA_6_3_4,4,3}},
        {L"ESDIRK437L2SA_7_3_4",{ARKODE_ERK_NONE,ARKODE_ESDIRK437L2SA_7_3_4,4,3}},
        {L"ESDIRK547L2SA_7_4_5",{ARKODE_ERK_NONE,ARKODE_ESDIRK547L2SA_7_4_5,5,4}},
        {L"ESDIRK547L2SA2_7_4_5",{ARKODE_ERK_NONE,ARKODE_ESDIRK547L2SA2_7_4_5,5,4}},

        // implicit/explicit (ImEx) methods
        {L"ARK",{ARKODE_ARK436L2SA_ERK_6_3_4,ARKODE_ARK436L2SA_DIRK_6_3_4,4,3}},
        {L"ARK324",{ARKODE_ARK324L2SA_ERK_4_2_3,ARKODE_ARK324L2SA_DIRK_4_2_3,3,3}},
        {L"ARK436",{ARKODE_ARK436L2SA_ERK_6_3_4,ARKODE_ARK436L2SA_DIRK_6_3_4,4,3}},
        {L"ARK548",{ARKODE_ARK548L2SA_ERK_8_4_5,ARKODE_ARK548L2SA_DIRK_8_4_5,5,4}},
        {L"ARK548b",{ARKODE_ARK548L2SAb_ERK_8_4_5,ARKODE_ARK548L2SAb_DIRK_8_4_5,5,4}},
        {L"ARK437",{ARKODE_ARK437L2SA_ERK_7_3_4,ARKODE_ARK437L2SA_DIRK_7_3_4,4,3}}
    };

    std::vector<std::wstring> getAvailableMethods()
    {
        std::vector<std::wstring> availableMethods;
  
        for (const auto &it : vectARKODEMethods)
        {
            if ((m_odeIsImEx == false && hasJacobian() == false) 
                && (it.second.erkID == ARKODE_ERK_NONE || it.second.dirkID == ARKODE_DIRK_NONE)
                || (m_odeIsImEx  && it.second.erkID >= ARKODE_MIN_ERK_NUM && it.second.dirkID >= ARKODE_MIN_DIRK_NUM)
                || (hasJacobian() && it.second.erkID == ARKODE_ERK_NONE && it.second.dirkID >= ARKODE_MIN_DIRK_NUM))
            {
                 availableMethods.push_back(it.first);
            }
        }
  
        return availableMethods;
    }

    virtual std::wstring getMethodName()
    {
        methodInfo info = ARKODEMethods[m_wstrMethod];
        // init with m_wstrMethod for the user tableaux case ("info" above will be uninitialized)
        std::wstring wstrMethodFullName = m_wstrMethod;
        for (const auto &it : vectARKODEMethods)
        {
            // last matching has the full name
            if (it.second.erkID == info.erkID && it.second.dirkID == info.dirkID)
            {
               wstrMethodFullName = it.first;
            }
        }
        return wstrMethodFullName;
    }

    int getMaxMethodOrder(std::wstring wstrMethod)
    {
        return m_odeIsImEx ? 5 : 8;
    }

    bool hasBandPrec()
    {
        return true;
    }
private :

    ARKODEManager* m_prevManager = NULL;

    int m_iMethodOrder = 0;
    int m_iEmbeddedMethodOrder = 0;
    std::wstring m_wstrInterpolationMethod;
    std::wstring m_wstrIsLinear;
    int m_iInterpolationDegree = 0;
    int m_iInterpolationMethod = 0;
    long int m_incStat[10] = {0, 0, 0, 0, 0, 0, 0, 0, 0};
    double m_dblFixedStep = 0;
    ARKodeButcherTable m_ERKButcherTable = NULL;
    ARKodeButcherTable m_DIRKButcherTable = NULL;
};

#endif
