#!usr/bin/env python

#targets=[list of targets]; trig=triggers plant immune response? [True/False] if False, then inhibits

#Step 1 define the network
import PyBoolNet
class effector:
    def __init__(self, name, targets, trig, key, t):
        self.name = name #list with nodes names
        self.targets = targets #the names of the nodes from which each node is Connected (list of lists)
        self.trig = trig #a binary value to denote if the connected node needs to be present or absent for their activation
        self.key=key # a key for either effectors or resistance genes
        self.time= t
#Step 2 simulate the network at t=n timepoints        
'''
brew install imagemagick
brew install graphviz
#how to import a python package from a different location??
    def sim_net(field)
        field.name
        field.targets
        field.trig
        field.key
        for field in fields

        nodes = self.name 
        conn_nodes= self.targets 
        boolfunc_value= self.trig 

        truth= a table of truth tables of the 2**conn
'''

e1 = effector(["a","b","c"],[["a", "b"], ["a", "b","c"], ["b"]],
 [[True, False], [True, True, False], [False]],["E","E","R"], 10)


print(e1.name)



'''
i_value= initial state list of starting state for each node in the nave values (can be set random) (boolean)
i_value=[0,0,0] or i_value= random   
conn2val= the output for the truth table (can be random) (boolean)
value=updated values for time t+1 (boolean)'''

#Step 3 analyse the network dynamics to obtain redundancy and pleiotropic effects



