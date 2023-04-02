# -*- coding: utf-8 -*-
"""
Created on Mon Sep 18 09:01:11 2017

@author: adam
"""

from __future__ import print_function

import os

import cPickle as pickle

import numpy as np
import pandas as pd

from zss import simple_distance, Node

def load_tree(fpath):
    swc_df = pd.read_csv(fpath,
                         sep=' ',
                         comment='#',
                         header=None,
                         usecols=[0,1,6],
                         index_col=0,
                         names=['id','ctype','parent'])
    
    tree_df = swc_df.query("ctype==4")[['parent']]
    
    tree_df = tree_df.assign(num_child=0,
                             children=[[] for _ in xrange(tree_df.shape[0])])
    
    for i in tree_df.index[1:]:
        pid = tree_df.loc[i,'parent']
        tree_df.loc[pid,'num_child'] += 1
        tree_df.loc[pid,'children'].append(i)
    
    def tree_from_idx(i):
        if tree_df.loc[i,'num_child']==0:
            return (1,Node(None))
        elif tree_df.loc[i,'num_child']==1:
            return tree_from_idx(tree_df.loc[i,'children'][0])
        else:
            nd = Node(None)
            children = map(tree_from_idx,tree_df.loc[i,'children'])
            children.sort(reverse=True)
            ct = 1
            for n,ch in children:
                ct += n
                nd.addkid(ch)
            return (ct,nd)
    
    tree_nd = tree_from_idx(tree_df.index[0])
    return tree_nd


if __name__ == '__main__':
    
    ############ GET TREE DATA AND MAKE DISTMAT
#    data_name = 'Chen'
    data_name = 'Wu'
    data_path = '/home/adam/Dropbox/AxonalTreeGeometry/data/' + data_name + '/'
    data_path += 'CNG version/'
    
    fnames = sorted(os.listdir(data_path))
    N = len(fnames)
    
    print('Loading {:d} trees...'.format(N))
    
    trees = [load_tree(data_path+fname) for fname in fnames]
    
    
    print('Building {:d}x{:d} distmat...'.format(N,N))
    
    D = np.empty((N,N))
    for i in xrange(N-1):
        for j in xrange(i+1,N):
            print('({:d},{:d})...'.format(i,j),end='')
            D[i,j] = D[j,i] = simple_distance(trees[i][1],trees[j][1])
    print('\n')
    
    # save processed data
    with open(data_name+'_zss_trees.pkl','wb') as f:
        pkldict = {
        'data_name' : data_name,
        'data_path' : data_path,
        'fnames' : fnames,
        'trees' : trees,
        'D' : D
        }
        pickle.dump(pkldict,f,protocol=2)
    