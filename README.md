# OBASK Knowledge Graph

A repository for the OBASK knowledge graph.

## Build and Run
To build the project, clone the project to your computer and run the following commands in the project root folder:
```
docker build -t obask/obask-kb .
```

To run the built Docker image:
```
docker run -d -p:7474:7474 -p 7687:7687 obask/obask-kb
```

## Browse KB
Open http://localhost:7474/browser/ in your browser. You do not need to enter any `Username` or `Password`, so you can leave these fields blank.

Click the `Database` icon in the upper left corner . Under the `Node Labels` section, you can find the labels of the KB entities. Click on one of the labels and start browsing.


### _Debug Running Container [Optional]_
Please follow the given steps to make sure the KB starts successfully.

To find the ID of the started Docker container run:
```
docker ps
```

Copy the container ID and then run:
```
docker logs --follow CONTAINER_ID
```

You should see `Started.` in the logs. To report any abnormal behavior, please [create an issue](https://github.com/OBASKTools/obask-kb/issues/new).