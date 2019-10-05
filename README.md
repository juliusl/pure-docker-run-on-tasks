# pure-docker-run-on-tasks
How to run an image without additional volume mounting.

In some cases in your multi step task yaml file you want to run an intermediate step before pushing your image to the registry, without any of the tooling ACR adds to the container. f. ex.

```
# build image
# run an intermediate script in the image for some validation
# push image to your registry
```

This repo gives example code on how to achieve that. 

To try it out (With the assumption you're already a Tasks user):

1) Clone this repo
2) Change your directory to this repo's root
3) On your command line run `az login`
4) Next run `az acr run -f tasks.yaml . --registry <your-registry-name>`

Your output should include a line:

`Found folder`

If for example the `ssh_config` file was missing the intermediate script would return exit code 1, and your output would include lines such as:

```
Did not find folder
2019/10/05 01:02:49 Container failed during run: scratchscriptsverify. No retries remaining.
failed to run step ID: scratchscriptsverify: exit status 1
```

Which will stop the multi-step tasks from completeing.
