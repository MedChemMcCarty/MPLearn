
install_prereqs:
	conda install setuptools pandas joblib scikit-learn umap-learn nodejs
	conda install -c conda-forge umap-learn hbscan jupyterlab datashader holoviews
	conda install -c pyviz panel
	pip install nbdev

	wget https://files.pythonhosted.org/packages/59/9c/972de8fb6246be6557a16565c4cc1977ea9e275540a77ec4a2e0057dc593/tf_nightly-2.2.0.dev20200228-cp38-cp38-manylinux2010_x86_64.whl
	pip install tf_nightly-2.2.0.dev20200228-cp38-cp38-manylinux2010_x86_64.whl

	# make jupyter lab work with holoviews
        jupyter labextension install jupyterlab_bokeh
        jupyter labextension install @pyviz/jupyterlab_pyviz
        echo "c = get_config()" >> $(jupyter --config_dir)/jupyter_notebook_config.py
	echo "c.NotebookApp.iopub_data_rate_limit=100000000" >> $(jupyter --config_dir)/jupyter_notebook_config.py

install:
	python setup.py install

run_Steatosis2020_vignette:
	# generate umap embeddings and density based clusterings
	# produces
	#    intermediate_data/<dataset_tag> with processed features different data subsamples
	#    intermediate_data/<embedding_tag> directory with embeddings and clusterings
	#    product/figures/<embedding_tag>_embedding.png with images of the embeddings
	cd vignettes/Steatosis2020/umap_embedding_202017
	jupyter lab
	# on local machine:
	#   ssh -i "<ec2_instance_id>.pem" -NfL 8887:localhost:8888 ubuntu@<instance_url>
	#      where <ec2_instance_id> is the Amazon EC2 .pem file
	#      and <instance_url> is the IP or URL to the instance
	#   natigate browser to localhost:8887
	#   put in security token
	python scripts/1_init.py
	python scripts/2_load_data.py
	./scripts/3_embed_umap_2D.sh

start_local_dask_cluster:
	dask-scheduler --scheduler-file temp/scheduler.json &
	dask-worker --shceduler-file temp/scheduler.json &

start_Steatosis2020_vignette_notebooks:
	# note the secret token
	# on local machine:
	#   ssh -i "sextonlab_linux.pem" -NfL 8887:localhost:8888 ubuntu@ec2-3-20-192-55.us-east-2.compute.amazonaws.com
	#   natigate browser to localhost:8886
	#   put in security token
