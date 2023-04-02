# -*- coding: utf-8 -*-
"""
Created on Wed Mar  2 13:28:50 2016

@author: adam
"""

from __future__ import print_function
from __future__ import division

import os
from time import time

import cPickle as pickle

from scipy.io import loadmat

import numpy as np

from sklearn.preprocessing import StandardScaler
from sklearn.cross_validation import LeaveOneOut
from sklearn.cross_validation import StratifiedKFold
#from sklearn.model_selection import LeaveOneOut
#from sklearn.model_selection import StratifiedKFold
from sklearn import svm

from sklearn.metrics import confusion_matrix
from sklearn.metrics import accuracy_score

#from sklearn.manifold import MDS

import matplotlib.pyplot as plt
import clf_ex_plot_fcns as clf_plt

def RBF_CVClassify_(x,y,cv_itr, C_range,gamma_range):
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


def RBF_CVClassify(X,y,cv_itr, C_range,gamma_range, kernel='rbf'):
    
    N = np.size(y)
    N_C = len(C_range)
    N_gamma = len(gamma_range)
    
    y_pred = np.empty((N_C,N_gamma,N),dtype=int)
    acc_grid = np.empty((N_C,N_gamma))
    
    
    for j in xrange(N_gamma):
        gamma = gamma_range[j]
        for i in xrange(N_C):
            C = C_range[i]
            for trn_idx,tst_idx in cv_itr:
                y_train = y[trn_idx]
                X_train = X[trn_idx,:] 
                X_test = X[tst_idx,:] 
                
#                svc = svm.SVC(C=C,kernel=kernel,gamma=gamma,class_weight='balanced')
                svc = svm.SVC(C=C,kernel=kernel,gamma=gamma)
                svc.fit(X_train,y_train)

                y_pred[i,j,tst_idx] = svc.predict(X_test)
    
    for i in xrange(N_C):
        for j in xrange(N_gamma):
            acc_grid[i,j] = accuracy_score(y,y_pred[i,j,:])
    
    iC,iG = np.unravel_index(acc_grid.argmax(), acc_grid.shape)
    C = C_range[iC]
    gamma = gamma_range[iG]
    
#    Grbf = np.exp(-gamma*Dq)
#    l = np.min(np.linalg.eig(Grbf)[0])
#    print('Smallest eigenvalue: {:f}'.format(l))
#    if l<0:
#        print(' ! ! ! KERNEL NOT PD ! ! !')
    return y_pred,acc_grid,C,gamma,(iC,iG)

if __name__ == "__main__":
    plt.close('all')
    
    data_name = 'wu_12072016'
#    data_name = 'chen_12022016'
    y_name = 'grps'
#    y_name = 'region'
#    y_name = 'expcond'
    kfolds = 5 # 0 means LOO
    
        
    ### define parameter grid
#    # 2-3 categories Chen, Wu, IBV
#    logCmin,logCmax = -1,3
#    logCres = 8
#    logGmin,logGmax = -4,-0
#    logGres = 8
#    # 4-6 categories Chen
#    logCmin,logCmax = 0,4
#    logCres = 8
#    logGmin,logGmax = -3,1
#    logGres = 8
    # all?
    logCmin,logCmax = -1,4
    logCres = 8
    logGmin,logGmax = -5,2
    logGres = 8

    NC = logCres*(logCmax-logCmin)+1
    CVec = np.logspace(logCmin,logCmax,NC)
    NG = logGres*(logGmax-logGmin)+1
    GVec = np.logspace(logGmin,logGmax,NG)
    
#    kmax = 15

    # data location
    results_in_path = 'tmp_results/'+data_name+'/multialign/'
    in_files = os.listdir(results_in_path)
    Nfiles = len(in_files)
    
    matlab_data = loadmat(results_in_path+in_files[0])
    y = matlab_data[y_name][0]
    N = y.size
    
    if kfolds > 0:
        exstr = 'Strat{:d}'.format(kfolds)
        cv_itr = StratifiedKFold(y,kfolds)
    else:
        exstr = 'LOO'
        cv_itr = LeaveOneOut(N)
    
    exstr += '_' + y_name + '_PC'
    
    
    ## for IBV, label classes by: 1 = WT, 2 = KO (any)
    # exstr += '2'
    #y = np.array([(2 if l<4 else 1) for l in y])
    
    
    # data/results containers
    lam = np.empty([Nfiles,3])
    X = [None]*Nfiles
    
#    pstr = [None]*Nfiles
    
    y_pred = [None]*Nfiles
    acc_grid = [None]*Nfiles
    
    best_acc = np.empty(Nfiles)
#    best_C = np.empty(Nfiles)
#    best_gamma = np.empty(Nfiles)
    best_idx = np.empty((Nfiles,2),dtype=int)
#    best_k = np.empty(Nfiles, dtype=int)
    
    prop_same = [None]*Nfiles
    
    for i in xrange(Nfiles): 
        start = time()
        
        matlab_data = loadmat(results_in_path+in_files[i])
        lam[i,0] = matlab_data['lam_m'][0,0]
        lam[i,1] = matlab_data['lam_s'][0,0]
        lam[i,2] = matlab_data['lam_p'][0,0]
        print( "{:d} of {:d}".format(i+1,Nfiles) )
        print( "lam_m/s = ({:.0e}, {:.0e})".format(lam[i,0],lam[i,1]) )
        
        X[i] = matlab_data['Z']
        
        # call cv clf wrapper
        y_pred[i],acc_grid[i],C,gamma,best_idx[i,:] \
            = RBF_CVClassify(X[i],y,cv_itr,CVec,GVec)
#        y_pred[i],acc_grid[i],best_k[i] = kNN_CVClassify(D[i],y,cv_itr,kmax)
        
        best_acc[i] = np.max(acc_grid[i])
        print( "Accuracy = {:f}".format(best_acc[i]) )
        print( "With C = {:.2e} and gamma = {:.2e}".format(C,gamma) )
#        print( "With k = {}".format(best_k[i]))
        
        prop_same[i] = np.mean(y_pred[i],2)-1 # SVM
#        prop_same[i] = np.mean(y_pred[i],1)-1 # kNN
        prop_same[i] = np.maximum(prop_same[i],1-prop_same[i])
        
        print( "{:2.3f} seconds\n".format(time()-start) )
    
    all_best_i = np.where(best_acc==best_acc.max())[0]
    all_best = [( np.sum(acc_grid[i]==best_acc.max()), i ) for i in all_best_i]
    imax = max(all_best)[1]
    
    (iC,iG) = best_idx[imax,:]
    C = CVec[iC]
    gamma = GVec[iG]
    
    print("Best:")
    print( "lam_m/s = ({:.0e}, {:.0e})".format(lam[imax,0],lam[imax,1]) )
    print( "Accuracy = {:f}".format(best_acc[imax]) )
    print( "With C = {:.2e} and gamma = {:.2e}".format(C, gamma) )
#    print( "With k = {}".format(best_k[i]) )
    
    best_ypred = y_pred[imax][iC,iG,:]
    best_confmat = confusion_matrix(y,best_ypred)
    k_cat = best_confmat.shape[0]
    
    print(best_confmat)
    
    ##################################################
    ##### SAVE RESULTS 
    ##################################################
    results_out_path = 'tmp_results/'+data_name+'/classification/'
    with open(results_out_path+exstr+'.pkl','wb') as f:
        pkldict = {
        'logCmin':logCmin,'logCmax':logCmax,'logCres':logCres,'NC':NC,'CVec':CVec,
        'logGmin':logGmin,'logGmax':logGmax,'logGres':logGres,'NG':NG,'GVec':GVec,
        'Nfiles':Nfiles, 'lam':lam, 
        'best_lam_file':results_in_path+in_files[imax],
        'acc_grid':acc_grid, 'best_acc':best_acc, 'prop_same':prop_same,
        'C':C,'gamma':gamma, 'best_idx':best_idx,'imax':imax,
        'y_pred':best_ypred, 'confmat':best_confmat,
        'data_name':data_name
        }
        pickle.dump(pkldict,f,protocol=2)
    
    
    ##################################################
    ##### PLOTS (and info.txt summary )
    ##################################################
    
    figpath = 'tmp_figs/'+data_name+'/classification/'
    figpath += exstr + '/'
    if not os.path.exists(figpath):
        os.makedirs(figpath)
    
    with open(figpath+'info.txt','w') as f:
        f.write('Success rate: {:6.4f}\n'.format(best_acc[imax]))
        f.write('Confusion matrix:\n')
        print(best_confmat,file=f)
        f.write('\n')
        
        f.write('Best Parameters:\n')
        f.write('  lam_m = {:.3e}\n'.format(lam[imax,0]))
        f.write('  lam_s = {:.3e}\n'.format(lam[imax,1]))
        f.write('  lam_p = {:.3e}\n'.format(lam[imax,2]))
        f.write('  C     = {:.3e}\n'.format(C))
        f.write('  gamma = {:.3e}\n\n'.format(gamma))
        
        f.write('SVM Parameter Grid:\n')
        f.write('  logCmin = {:f}\n'.format(logCmin))
        f.write('  logCmax = {:f}\n'.format(logCmax))
        f.write('  logCres = {:f}\n'.format(logCres))
        f.write('  NC      = {:d}\n'.format(NC))
        f.write('  logGmin = {:f}\n'.format(logGmin))
        f.write('  loggmax = {:f}\n'.format(logGmax))
        f.write('  loggres = {:f}\n'.format(logGres))
        f.write('  NG      = {:d}\n\n'.format(NG))
        
        f.write('lambdas used:\n')
        for i in xrange(Nfiles):
            f.write("  {:.0e}, {:.0e}, {:3.1f}\n".format(lam[i,0],lam[i,1],lam[i,2]) )
    
    plt.close('all')
    plt.ion()
    
    fig_sz = (3,3)
    fig_fontsize = 9
    
#    ### accuracy on lambda m/s grid
    clf_plt.plot_lam_grid(lam,best_acc, base_acc=1.0/k_cat, max_sz=60,
                          figsize=fig_sz, fontsize=fig_fontsize)
    plt.savefig(figpath+'accuracy_v_lambda.png')
    
#    ### distmat
#    plt.figure(figsize=fig_sz)
#    plt.imshow(D[imax], interpolation='nearest', cmap=plt.cm.gray)
#    plt.tick_params(labelsize=fig_fontsize)
##    plt.colorbar()
#    plt.savefig(figpath+'distmat.png')
    
#    ### accuracy on C,gamma grid
    clf_plt.plot_cg_grid(acc_grid[imax],CVec,GVec,
                         figsize=fig_sz, fontsize=fig_fontsize)
    plt.savefig(figpath+'accuracy_v_cg.png')
    
#    ### uniformity on C,gamma grid
    clf_plt.plot_cg_grid(prop_same[imax],CVec,GVec,
                         figsize=fig_sz, fontsize=fig_fontsize)
    plt.savefig(figpath+'uniformity_v_cg.png')
    
#    ### mds plot
#    clf_plt.mds_plot(D,y,figsize=fig_sz, fontsize=fig_fontsize)
#    plt.savefig(figpath+'mds_plots.png')