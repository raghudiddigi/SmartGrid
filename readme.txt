This contains implementations for 3 agents and 5 agents. Below we explain contents of each file. 

data_processing.m : This is to obtain poisson mean from the data collected from RAPsim. Data file is 'first_model'
multiagent_FinalwithADL.m : This is our main 'ADL-sharing' model.
multiagent_FinalwithADL_comp1.m : This is the comparison 'Greedy-ADL' model.
multi_agent_version2.m : This is the comparison 'Non-ADL' model. 

Other .m files : Auxillary codes used by the above codes.

Running the codes :

Step 1: Run the code "data_processing.m" first for initializing poisson means globally for both 3 agents and 5 agents.
Step 2: Run the desired model.