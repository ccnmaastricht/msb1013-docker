ARG PYTHON_VERSION=3.10
FROM continuumio/miniconda3

LABEL image='MSB1013_jupyter'
LABEL version="0.1"
LABEL author="Mario Senden"
LABEL email="mario.senden@maastrichtuniversity.nl"

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
                  jupyterlab-github

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

CMD ["jupyter-lab","--ip=0.0.0.0","--port=8888", "--no-browser","--allow-root"]
