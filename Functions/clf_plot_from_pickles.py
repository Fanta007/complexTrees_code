# -*- coding: utf-8 -*-
"""
Created on Thu Feb 23 12:36:29 2017

@author: adam
"""

import os
import cPickle as pickle
from scipy.io import loadmat

#import numpy as np

import matplotlib.pyplot as plt
import clf_ex_plot_fcns as clf_plt

def redraw_elastic_example(dataname,exname,y_name='grps', save=True,
                           fig_sz = (3,3),fig_fontsize = 9,
                           lg_max_sz=60,
                           y_chars=None, y_labels=None ):
    datafile = 'tmp_results/'+dataname+'/classification/'+exname+'.pkl'
    with open(datafile,'rb') as f:
        pkldict = pickle.load(f)
    
    GVec = pkldict['GVec']
    CVec = pkldict['CVec']
    imax = pkldict['imax']
    best_acc = pkldict['best_acc']
    confmat = pkldict['confmat']
    lam = pkldict['lam']
    acc_grid = pkldict['acc_grid']
    prop_same = pkldict['prop_same']
    
    best_lam_file = pkldict['best_lam_file']
    
    matlab_data = loadmat(best_lam_file)
    D = matlab_data['distmat']
    y = matlab_data[y_name][0]
    
    k_cat = confmat.shape[0]
    
    
    ### figs for full summary
    figpath = 'tmp_figs/' + dataname + '/classification/' + exname + '/'
    if not os.path.exists(figpath):
        os.makedirs(figpath)
    
    
    figs = [None]*5
    
    ### accuracy on lambda m/s grid
    figs[0] = clf_plt.plot_lam_grid(lam,best_acc, base_acc=1.0/k_cat, max_sz=lg_max_sz,
                                    figsize=fig_sz, fontsize=fig_fontsize)
    if save:
        plt.savefig(figpath+'accuracy_v_lambda.png')
    
    ### distmat
    figs[1] = plt.figure(figsize=fig_sz)
    plt.imshow(D, interpolation='nearest', cmap=plt.cm.gray)
    plt.tick_params(labelsize=fig_fontsize)
    if save:
        plt.savefig(figpath+'distmat.png')
    
    ### accuracy on C,gamma grid
    figs[2] = clf_plt.plot_cg_grid(acc_grid[imax],CVec,GVec,
                                   figsize=fig_sz, fontsize=fig_fontsize)
    if save:
        plt.savefig(figpath+'accuracy_v_cg.png')
    
    ### uniformity on C,gamma grid
    figs[3] = clf_plt.plot_cg_grid(prop_same[imax],CVec,GVec,
                                   figsize=fig_sz, fontsize=fig_fontsize)
    if save:
        plt.savefig(figpath+'uniformity_v_cg.png')
    
    ### mds plot
    figs[4] = clf_plt.mds_plot(D,y,y_chars=y_chars,y_labels=y_labels,
                               figsize=fig_sz, fontsize=fig_fontsize)
    if save:
        plt.savefig(figpath+'mds_plot.png')
    
    return figs
    

if __name__ == "__main__":
    
    plt.close('all')
    plt.ion()
    

#    lg_sz = 60
#    dataname = 'wu_12072016'
#    
#    y_name = 'grps'
#    exname = 'Strat5_'+y_name
#    y_labels = {1:'KO',2:'WT'}
#    redraw_elastic_example(dataname,exname,y_name, save=True,
#                           lg_max_sz=lg_sz, y_labels=y_labels)
    
    
    lg_sz = 200
    dataname = 'chen_12022016'
    
    y_name = 'grps'
    exname = 'Strat5_'+y_name
    y_labels = {1:'H-C',2:'H-B1',3:'H-B2',4:'N-C',5:'N-B1',6:'N-B2'}
    figs = redraw_elastic_example(dataname,exname,y_name, save=False,
                                  lg_max_sz=lg_sz, y_labels=y_labels)
    
    asdf = figs[4]
    
#    y_name = 'expcond'
#    exname = 'Strat5_'+y_name
#    y_labels = {1:'Control',2:'BDL',3:'BDLHD'}
#    figs = redraw_elastic_example(dataname,exname,y_name, save=True,
#                                  lg_max_sz=lg_sz, y_labels=y_labels)
#    
#    y_name = 'region'
#    exname = 'Strat5_'+y_name
#    y_labels = {1:'H',2:'N'}
#    figs = redraw_elastic_example(dataname,exname,y_name, save=True,
#                                  lg_max_sz=lg_sz, y_labels=y_labels)
    
#    print figs[0].get_size_inches()
#    print figs[0].get_dpi()
    
