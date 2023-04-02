# -*- coding: utf-8 -*-
"""
Created on Mon Sep 18 09:01:11 2017

@author: adam
"""

from __future__ import print_function

import os
import re

import cPickle as pickle

import numpy as np
import pandas as pd

from zss import simple_distance, Node

from sklearn import svm
from sklearn.metrics import confusion_matrix
from sklearn.metrics import accuracy_score
from sklearn.model_selection import LeaveOneOut
from sklearn.model_selection import StratifiedKFold

import matplotlib.pyplot as plt
import clf_ex_plot_fcns as clf_plt


def kNN_CVClassify(D,y,cv_itr, kmax=None):
    N = y.size
    if kmax is None: # then use sqrt of largest class size
        kmax = int(np.min(np.sqrt(np.bincount(y)[np.unique(y)])))
    
    y_pred = np.empty((kmax,N),dtype=int)
    acc_vec = np.empty(kmax)
    
    for trn_idx,tst_idx in cv_itr.split(D,y):
        y_train = y[trn_idx]
        D_test = D[tst_idx,:][:,trn_idx] # dists tst to trn
        
        # get labels in row i in order by nearest to i
        kNN_inds = np.argsort(D_test) 
        kNN_ysorted = y_train[kNN_inds] 
        
        for k in xrange(1,kmax+1):
            for i,i0 in enumerate(tst_idx):
                y_pred[k-1,i0] = np.argmax(np.bincount(kNN_ysorted[i,:k]))
    
    for k in xrange(kmax):
        acc_vec[k] = np.mean(y==y_pred[k,:])
    
    k = np.argmax(acc_vec)+1
    
    return y_pred,acc_vec,k

def RBF_CVClassify(D,y,cv_itr, C_range,gamma_range, q=2):
    Dq = D**q
    
    N = np.size(y)
    N_C = len(C_range)
    N_gamma = len(gamma_range)
    
    y_pred = np.empty((N_C,N_gamma,N),dtype=int)
    acc_grid = np.empty((N_C,N_gamma))
    
    
    for j in xrange(N_gamma):
        gamma = gamma_range[j]
        Grbf = np.exp(-gamma*Dq)
        for i in xrange(N_C):
            C = C_range[i]
            for trn_idx,tst_idx in cv_itr.split(D,y):
                y_train = y[trn_idx]
                Grbf_train = Grbf[trn_idx,:][:,trn_idx] # dists trn to trn
                Grbf_test = Grbf[tst_idx,:][:,trn_idx] # dists tst to trn
                
#                svc = svm.SVC(C=C,kernel='precomputed',class_weight='balanced')
                svc = svm.SVC(C=C,kernel='precomputed')
                svc.fit(Grbf_train,y_train)

                y_pred[i,j,tst_idx] = svc.predict(Grbf_test)
    
    for i in xrange(N_C):
        for j in xrange(N_gamma):
            acc_grid[i,j] = accuracy_score(y,y_pred[i,j,:])
    
    iC,iG = np.unravel_index(acc_grid.argmax(), acc_grid.shape)
    C = C_range[iC]
    gamma = gamma_range[iG]
    
    Grbf = np.exp(-gamma*Dq)
    l = np.min(np.linalg.eig(Grbf)[0])
    print('Smallest eigenvalue: {:f}'.format(l))
    if l<0:
        print(' ! ! ! KERNEL NOT PD ! ! !')
    return y_pred,acc_grid,C,gamma,(iC,iG)


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


if __name__ == '__main__':
    plt.close('all')
    
    ############### DEFINE PARAMETER GRID
#    ## same as for elastic
#    logCmin,logCmax = -1,4
#    logCres = 8
#    logGmin,logGmax = -5,0
#    logGres = 8
    ## wider
    logCmin,logCmax = -2,8
    logCres = 8
    logGmin,logGmax = -9,1
    logGres = 8

    NC = logCres*(logCmax-logCmin)+1
    CVec = np.logspace(logCmin,logCmax,NC)
    NG = logGres*(logGmax-logGmin)+1
    GVec = np.logspace(logGmin,logGmax,NG)

    ############### CHOOSE DATA
#    save_loc = 'chen_12022016'
#    data_name = 'Chen'
#    name2y_fcn = chen_y_from_name
    save_loc = 'wu_12072016'
    data_name = 'Wu'
    name2y_fcn = wu_y_from_name
    
    y_name = 'grps'
#    y_name = 'region'
#    y_name = 'expcond'
    kfolds = 5 # 0 means LOO
    
    q = 2
#    kmax = 15
    
    ############ LOAD DATA
    print('Loading pickle...')
    
    datafile = data_name+'_zss_trees.pkl'
    with open(datafile,'rb') as f:
        pkldict = pickle.load(f)
    
    data_name = pkldict['data_name']
    data_path = pkldict['data_path']
    fnames = pkldict['fnames']
    trees = pkldict['trees']
    D = pkldict['D']
    
    N = len(fnames)
    
    y_df = y_df_from_names(fnames, name2y_fcn)
    y = np.array(y_df[y_name])
    
    ############### NAME EXPERIMENT AND RUN CLASSIFIER
    if kfolds > 0:
        exstr = 'Strat{:d}'.format(kfolds)
        cv_itr = StratifiedKFold(kfolds)
    else:
        exstr = 'LOO'
        cv_itr = LeaveOneOut(N)
    
    exstr += '_' + y_name + '_TED'
#    exstr += '_' + y_name + '_kNN_TED'
    
    print('Running cv clf...')
    # call cv clf wrapper
    D = D/np.mean(D)
    y_pred,acc_grid,C,gamma,(iC,iG) = RBF_CVClassify(D,y,cv_itr,CVec,GVec,q=q)
#    y_pred,acc_vec,best_k = kNN_CVClassify(D,y,cv_itr,kmax)
    
    # RBF results
    best_acc = acc_grid[iC,iG]
    best_ypred = y_pred[iC,iG,:]
    confmat = confusion_matrix(y,best_ypred)
    
    print( "Accuracy = {:f}".format(best_acc) )
    print( "With C = {:.2e} and gamma = {:.2e}".format(C, gamma) )
    
    print(confmat)
    
#    # kNN results
#    best_acc = np.max(acc_vec)
#    best_ypred = y_pred[best_k+1,:]
#    
#    confmat = confusion_matrix(y,best_ypred)
#    print( "Accuracy = {:f}".format(best_acc) )
#    print( "With k = {:d}".format(best_k) )
#    
#    print(confmat)
    
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
        
        # RBF param info
        f.write('SVM Parameter Grid:\n')
        f.write('  logCmin = {:f}\n'.format(logCmin))
        f.write('  logCmax = {:f}\n'.format(logCmax))
        f.write('  logCres = {:f}\n'.format(logCres))
        f.write('  NC      = {:d}\n'.format(NC))
        f.write('  logGmin = {:f}\n'.format(logGmin))
        f.write('  loggmax = {:f}\n'.format(logGmax))
        f.write('  loggres = {:f}\n'.format(logGres))
        f.write('  NG      = {:d}\n\n'.format(NG))
        
#        # kNN param info
#        f.write('Best k = {:d}\n'.format(best_k))
#        f.write('Max k = {:d}\n'.format(kmax))
    
#    xti = np.arange(0,NG,logGres,dtype=int)
#    yti = np.arange(0,NC,logCres,dtype=int)
#    
#    xtlbl = [r'$10^{'+str(int(pwr))+r'}$' for pwr in xti/logGres+logGmin]
#    ytlbl = [r'$10^{'+str(int(pwr))+r'}$' for pwr in yti/logCres+logCmin]

    
    ### figs for full summary
    plt.close('all')
    plt.ion()

    fig_sz = (3,3)
    fig_fontsize = 9
    
    ### accuracy on C,gamma grid
    clf_plt.plot_cg_grid(acc_grid,CVec,GVec,
                         figsize=fig_sz, fontsize=fig_fontsize)
    plt.savefig(figpath+'accuracy_v_cg.png')
    
    ### mds plot
    clf_plt.mds_plot(D,y, figsize=fig_sz, fontsize=fig_fontsize)
    plt.savefig(figpath+'mds_plot.png')
    
    