# -*- coding: utf-8 -*-
"""
Created on Wed Feb 15 13:41:05 2017

@author: adam
"""

from __future__ import print_function

import os
import re

import numpy as np
import pandas as pd

from sklearn.preprocessing import StandardScaler
from sklearn import svm
from sklearn.metrics import confusion_matrix
from sklearn.metrics import accuracy_score
from sklearn.model_selection import LeaveOneOut
from sklearn.model_selection import StratifiedKFold

import matplotlib.pyplot as plt
import clf_ex_plot_fcns as clf_plt


def RBF_CVClassify(x,y,cv_itr, C_range,gamma_range):
    N = np.size(y)
    N_C = len(C_range)
    N_gamma = len(gamma_range)
    
    y_pred = np.empty((N_C,N_gamma,N),dtype=int)
    acc_grid = np.empty((N_C,N_gamma))
    
    for trn_idx,tst_idx in cv_itr:
        scaler = StandardScaler()
        x_train = scaler.fit_transform(x[trn_idx,:])
        x_test = scaler.transform(x[tst_idx,:])
        
        y_train = y[trn_idx]
        for j in xrange(N_gamma):
            gamma = gamma_range[j]
            for i in xrange(N_C):
                C = C_range[i]
                
#                svc = svm.SVC(C=C,kernel='rbf',gamma=gamma,class_weight='balanced')
                svc = svm.SVC(C=C,kernel='rbf',gamma=gamma)
                svc.fit(x_train,y_train)

                y_pred[i,j,tst_idx] = svc.predict(x_test)
    
    for i in xrange(N_C):
        for j in xrange(N_gamma):
            acc_grid[i,j] = accuracy_score(y,y_pred[i,j,:])
    
    iC,iG = np.unravel_index(acc_grid.argmax(), acc_grid.shape)
    C = C_range[iC]
    gamma = gamma_range[iG]
    
    return y_pred,acc_grid,C,gamma,(iC,iG)


def get_meas(path):
    d = {}
    with open(path) as f:
        S = f.readlines()
    for s in S:
        m = re.match(r'\s*(.*?)\s*:\s*([0-9\.]*).*',s)
        d[m.group(1)] = float(m.group(2))
    
    return pd.Series(d)

def get_all_meas(path):
    fnames = os.listdir(path)
    fnames.sort()
    names_list = [s[:-4] for s in fnames]
    data_list = [get_meas(path+s) for s in fnames]
    return pd.DataFrame(data=data_list, index=names_list)



def chen_y_from_name(s):
    m = re.match(r'([A-Za-z]*)-([A-Z])',s)
    r = {'H':1, 'V':2}[m.group(2)]
    e = {'Con':1, 'BDL':2, 'BDLHD':3}[m.group(1)]
    g = 3*(r-1)+e
    e2 = min(e,2)
    g2 = 2*(r-1)+e2
    return {'region':r,'expcond':e,'grps':g,'expcond2':e2,'grps2':g2}

def wu_y_from_name(s):
    return {'grps': {'k':1,'w':2}[s[0]] }

def y_df_from_names(names_list, name2y_fcn):
    y_list = map(name2y_fcn, names_list)
    return pd.DataFrame(data=y_list, index=names_list)


if __name__ == "__main__":
    plt.close('all')

    ############### DEFINE PARAMETER GRID
    ## same as for elastic
    logCmin,logCmax = -1,4
    logCres = 8
    logGmin,logGmax = -5,0
    logGres = 8
#    ## lower-lefter
#    logCmin,logCmax = 1,6
#    logCres = 8
#    logGmin,logGmax = -6,-1 
#    logGres = 8

    NC = logCres*(logCmax-logCmin)+1
    CVec = np.logspace(logCmin,logCmax,NC)
    NG = logGres*(logGmax-logGmin)+1
    GVec = np.logspace(logGmin,logGmax,NG)

    ############### CHOOSE DATA
    save_loc = 'chen_12022016'
    data_name = 'Chen'
    name2y_fcn = chen_y_from_name
#    save_loc = 'wu_12072016'
#    data_name = 'Wu'
#    name2y_fcn = wu_y_from_name
    
#    y_name = 'grps'
#    y_name = 'region'
    y_name = 'expcond'
    kfolds = 5 # 0 means LOO
    
    
    ############ GET MEASUREMENT DATA
    data_path = '/home/adam/Dropbox/AxonalTreeGeometry/data/' + data_name + '/'
    meas_path = data_path + 'Measurements/'
    
    x_df = get_all_meas(meas_path)
    y_df = y_df_from_names(x_df.index, name2y_fcn)
    
    x = np.array(x_df)
    y = np.array(y_df[y_name])
    N = len(y)
    
    
    ############### NAME EXPERIMENT AND RUN CLASSIFIER
    if kfolds > 0:
        exstr = 'Strat{:d}'.format(kfolds)
#        cv_itr = StratifiedKFold(y,kfolds)
        cv_itr = StratifiedKFold(kfolds).split(x,y)
    else:
        exstr = 'LOO'
#        cv_itr = LeaveOneOut(N)
        cv_itr = LeaveOneOut(N).split(x)
    
    exstr += '_' + y_name + '_meas'
    
    y_pred,acc_grid,C,gamma,(iC,iG) = RBF_CVClassify(x,y,cv_itr, CVec,GVec)
    
    best_acc = acc_grid[iC,iG]
    best_ypred = y_pred[iC,iG,:]
    confmat = confusion_matrix(y,best_ypred)
    
    print( "Accuracy = {:f}".format(best_acc) )
    print( "With C = {:.2e} and gamma = {:.2e}".format(C, gamma) )
    
    print(confmat)
    
    ##################################################
    ##### PLOTS (and info.txt summary )
    ##################################################
    
    figpath = 'tmp_figs/'+save_loc+'/classification/'
    figpath += exstr + '/'
    if not os.path.exists(figpath):
        os.makedirs(figpath)
    
    with open(figpath+'info.txt','w') as f:
        f.write('Success rate: {:6.4f}\n'.format(best_acc))
        f.write('Confusion matrix:\n')
        print(confmat,file=f)
        f.write('\n')
        
        f.write('SVM Parameter Grid:\n')
        f.write('  logCmin = {:f}\n'.format(logCmin))
        f.write('  logCmax = {:f}\n'.format(logCmax))
        f.write('  logCres = {:f}\n'.format(logCres))
        f.write('  NC      = {:d}\n'.format(NC))
        f.write('  logGmin = {:f}\n'.format(logGmin))
        f.write('  loggmax = {:f}\n'.format(logGmax))
        f.write('  loggres = {:f}\n'.format(logGres))
        f.write('  NG      = {:d}\n\n'.format(NG))
    
    xti = np.arange(0,NG,logGres,dtype=int)
    yti = np.arange(0,NC,logCres,dtype=int)
    
    xtlbl = [r'$10^{'+str(int(pwr))+r'}$' for pwr in xti/logGres+logGmin]
    ytlbl = [r'$10^{'+str(int(pwr))+r'}$' for pwr in yti/logCres+logCmin]

    
    ### figs for full summary
    plt.close('all')
    plt.ion()

    fig_sz = (3,3)
    fig_fontsize = 9
    
#    ### accuracy on C,gamma grid
    clf_plt.plot_cg_grid(acc_grid,CVec,GVec,
                         figsize=fig_sz, fontsize=fig_fontsize)
    plt.savefig(figpath+'accuracy_v_cg.png')
    
#    ### accuracy on C,gamma grid
#    plt.figure(figsize=(8, 6))
#    #plt.subplots_adjust(left=.2, right=0.95, bottom=0.15, top=0.95)
#    plt.imshow(acc_grid, interpolation='nearest', cmap=plt.cm.hot)
#    plt.xlabel(r'$\gamma$')
#    plt.ylabel(r'$C$')
#    plt.colorbar()
#    plt.xticks(xti, xtlbl)
#    plt.yticks(yti, ytlbl)
#    plt.title('Validation Accuracy')
#    plt.savefig(figpath+'accuracy_v_cg.png')
    
#    ### uniformity on C,gamma grid
#    plt.figure(figsize=(8, 6))
#    #plt.subplots_adjust(left=.2, right=0.95, bottom=0.15, top=0.95)
#    plt.imshow(prop_same, interpolation='nearest', cmap=plt.cm.hot)
#    plt.xlabel(r'$\gamma$')
#    plt.ylabel(r'$C$')
#    plt.colorbar()
#    plt.xticks(xti, xtlbl)
#    plt.yticks(yti, ytlbl)
#    plt.title('Prediction Uniformity')
#    plt.savefig(figpath+'uniformity_v_cg.png')