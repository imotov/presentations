<!-- .slide: data-background="images/esbackground.png" data-state="eslogo" -->
# Task Management Framework for Elasticsearch 2.3 (WIP)
## Kick-off meeting



## Definitions


### Task

* Task is any *potentially* long running activity in elasticsearch
* Examples:  snapshot, restore, update by query, benchmark session, watcher, normal search


### Sub-tasks

* Task typically depends on a set of sub-tasks. 
* For example: snapshot consists of shard level snapshots.


### Coordinating node

* There is one typically a coordinating node that runs the task and a set of other nodes that runs subtasks.  
* Coordinating node can be a master or a node that received the user request.
* For search the coordinating node is the node that received the search request
* For snapshot the coordinating node is the master node


### Phases 

* The coordination between tasks and sub-tasks is a complex process that typically involves at least 3 phases: 
  * Initialization on coordinating node
  * execution on other nodes
  * ... might be more ...
  * reduction/finalization on the coordinating node. 


### Sub-task Affinity

* Sub-tasks might have an affinity to certain nodes (node type) or certain shards and depend on lifecycle of certain indices. 
* For example, a shard snapshot has to run on the primary shard and if the index is deleted during the snapshot, the snapshot should handle it correctly.



## Basic Functionality


### Registration

* We need to know which tasks and subtasks are currently running
* Should be very light-weight since we might want to extend this to register currently running searches


### Cancellation
 
* We should have an ability to cancel a task (might or might not be exposed directly to the user). 


### Lifecycle coordination

* Sub-tasks should be canceled when their task is cancelled or their dependent resource disappears. 
* The task should be able to start subtasks and get notified when subtasks are finished in a robust way (this is especially an issue if we need to survive restart of coordinating node)


### Task Resiliency

* depending on the task 
   1. it might be ok if tasks dies when its coordinating node dies, 
   2. it might need to survive restart of its coordinating node or 
   3. it might need to survive full restart of the entire cluster


### Sub-task resiliency
 
* sub task might need to be restarted if a node where it is running goes down
* the restart logic might be too complex for the task management framework to handle in generic way and should be responsibility of the task


## Execution Plan


### Phases

1. Registration/Cancellation with API
2. Support for coordinating node resiliency
3. Support for cluster restart resiliency


### Guinea Pig for Phase 1 and 2 - Snapshot/Restore

![Guinea Pig](images/taskmanagement/guinea-pig.jpg)

* Logic is well known to developers working on the task management framework
* Doesn't require new development
* Complex enough to work as a guinea pig


### Guinea Pig for Phase 3 - ???

![Guinea Pig](images/taskmanagement/guinea-pig-2.jpg)
