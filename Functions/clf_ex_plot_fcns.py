# -*- coding: utf-8 -*-
"""
Created on Thu Feb 23 12:36:29 2017

@author: adam
"""


import numpy as np
import matplotlib.pyplot as plt

from sklearn.manifold import MDS

def log_grid_ticks(X):
    xVec = np.log10(X)
    xt = np.arange(int(np.ceil(xVec[0])),int(np.ceil(xVec[-1]))+1)
    
    xti = np.empty(xt.shape,int)
    xtlbl = []
    for i,x in enumerate(xt):
        xti[i] = np.argmin( np.abs(x-xVec) )
        xtlbl.append( r'$10^{'+str(x)+r'}$' )
    
    return xti,xtlbl

def plot_lam_grid(lam,best_acc, base_acc=None,max_sz=500,
                  figsize=None,dpi=None,cmap=plt.cm.gray,fontsize=18):
    if base_acc is None:
        base_acc = np.min(best_acc)
    
    fig = plt.figure(figsize=figsize,dpi=dpi)
    plt.scatter(lam[:,0],lam[:,1], 
                s=max_sz*((best_acc-base_acc)/(1.0-base_acc))**2,
                c=best_acc, cmap=cmap)
#    plt.colorbar()
    
    plt.xlabel(r'$\lambda_m$',fontsize=fontsize)
    plt.xscale('log')
    plt.xlim((lam[:,0].min()/3,3*lam[:,0].max()))
    plt.ylabel(r'$\lambda_s$',fontsize=fontsize)
    plt.yscale('log')
    plt.ylim((lam[:,1].min()/3,3*lam[:,1].max()))
    plt.tick_params(labelsize=fontsize)
    
    plt.grid(True)
    plt.tight_layout()
    
    return fig

def plot_cg_grid(acc_grid, CVec, GVec, 
                 figsize=None,dpi=None,cmap=plt.cm.gray,title=None,fontsize=18):
    xti,xtlbl = log_grid_ticks(GVec)
    yti,ytlbl = log_grid_ticks(CVec)
    
    fig = plt.figure(figsize=figsize,dpi=dpi)
    plt.imshow(acc_grid, interpolation='nearest', cmap=cmap)
    plt.xlabel(r'$\gamma$', fontsize=fontsize)
    plt.ylabel(r'$C$', fontsize=fontsize)
#    plt.colorbar()
    plt.xticks(xti, xtlbl, fontsize=fontsize)
    plt.yticks(yti, ytlbl, fontsize=fontsize)
    if title is not None:
        plt.title(title)
    
    plt.tight_layout()
    
    return fig

def mds_plot(D,y,y_chars=None,y_labels=None,
             figsize=None,dpi=None,title=None,fontsize=18):
    
    if y_chars is None:
        y_chars = {1:'o',2:'*',3:'.',4:'v',5:'^',6:'<'}
    
    y_levels = np.unique(y)
#    if y_labels is None:
#        y_labels = {_:str(_) for _ in y_levels}
    
    em_dee_ess = MDS(dissimilarity='precomputed')
    Z = em_dee_ess.fit_transform(D)

    fig = plt.figure(figsize=figsize,dpi=dpi)
    for y0 in y_levels:
        ids = np.where(y==y0)[0]
        if y_labels is None:
            plt.plot(Z[ids,0],Z[ids,1],'k'+y_chars[y0])
        else:
            plt.plot(Z[ids,0],Z[ids,1],'k'+y_chars[y0], label=y_labels[y0])
    if y_labels is not None:
        plt.legend(numpoints=1,fontsize=fontsize)
    plt.tight_layout()
    return fig

