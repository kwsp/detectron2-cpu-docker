# CPU-only base image for pytorch + detectron2
FROM python:3.7-slim-buster

RUN apt-get update && apt-get install -y \
	build-essential libglib2.0-0 vim python3-dev git wget sudo && \
    rm -rf /var/lib/apt/lists/*

# Create a non root user
ARG USER_ID=1000
RUN useradd -m --no-log-init --system  --uid ${USER_ID} appuser -g sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER appuser
WORKDIR /home/appuser

ENV PATH="/home/appuser/.local/bin:${PATH}"

# Install dependencies
RUN pip install --user torch==1.4.0+cpu torchvision==0.5.0+cpu -f https://download.pytorch.org/whl/torch_stable.html; \
    pip install --user cython numpy
RUN pip install --user -U 'git+https://github.com/cocodataset/cocoapi.git#subdirectory=PythonAPI'

# Install detectron2
RUN git clone https://github.com/facebookresearch/detectron2 detectron2_repo
RUN pip install --user -e detectron2_repo

WORKDIR /home/appuser/detectron2_repo
