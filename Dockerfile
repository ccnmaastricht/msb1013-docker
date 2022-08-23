ARG PYTHON_VERSION=3.10
FROM continuumio/miniconda3

LABEL author="Mario Senden"
LABEL email="mario.senden@maastrichtuniversity.nl"
LABEL image="MSB1013_jupyter"
LABEL version="0.1"

RUN mkdir -p /home/computer_classes
RUN apt-get -y install git

# install jupyterlab plus nb_conda_kernels to enable
# several conda environments
RUN conda install python=$PYTHON_VERSION \
                  jupyterlab \
                  nb_conda_kernels \
                  numpy \
                  scipy \
                  matplotlib \
                  seaborn
RUN pip install   jupyterlab_latex \
		  jupyterlab-git \
                  jupyterlab-github

# copy jupyter configuration file
COPY jupyter_notebook_config.py /root/.jupyter/jupyter_notebook_config.py

# create environment for PyTorch machine learning framework
RUN conda create --name pytorch_env python=$PYTHON_VERSION \
		  ipykernel 
		 
# create environment for NEST simulator
RUN conda create --name nest_env -c conda-forge nest-simulator python ipykernel

# create environment for NEURON simulation environment
RUN conda create --name neuron_env python=$PYTHON_VERSION \
                  ipykernel \
                  numpy \
                  scipy \
                  matplotlib \
                  seaborn

SHELL ["conda", "run", "-n", "neuron_env", "/bin/bash", "-c"]
RUN pip install neuron

SHELL ["conda", "run", "-n", "pytorch_env", "/bin/bash", "-c"]
RUN pip install sklearn \
		torch \
		torchvision 

WORKDIR /home/computer_classes

CMD ["jupyter-lab","--ip=0.0.0.0", "--no-browser","--allow-root"]
EXPOSE 8888
