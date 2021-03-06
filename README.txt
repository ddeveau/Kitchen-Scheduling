Author  : Daniel DeVeau
Advisor : Dr. Kamesh Munagala
Edited  : August 31, 2017
Contact : danieldeveau81296@gmail.com

Kitchen Queues: A Scheduling Theory problem motivated by restaurant kitchens

Problem Statement:
    The goal of this study is to write an integer linear program (ILP) which optimally schedules a set of restaurant orders.
    What makes this problem unique is that all food items in an order must be completed together (no cold food).
    The inspiration for this study comes from my own experience as a frycook, where the cooking process was ripe with inefficiencies that ultimately decreased the overall customer experience.
    Popular sit-down chains use Kitchen Display System (KDS) technologies that aid these inefficiencies, but as of writing this I am not aware of any mathematical optimization used in the kitchen.

Model:
    A restaurant kitchen can be modeled by a set of m unique machines, representing cooking stations, each with a unique capacity.
    A food order is a set of jobs, where each job j has a processing time Pj and a machine Mj
    The goal is to schedule all jobs on their respective machines, minimizing the sum of order completion times.
    Constraints: 
            All jobs in an order must finish at the same time
            The number of simultaneous jobs on a machine must never exceed its capacity.

Notes:
    Assumptions:
        For simplicity, this project considers the offline batch scheduling scenario. Obviously, a practical system must schedule online as orders are placed.
        Additionally, the restaurant model has been simplified by removing appetizers/desserts, to assume that every customer orders 1 entree.
    Coldness:
        The w variable represents the "wait" or "coldness", meaning the allowed time units between the completion time of any job in an order and the completion time of the order.
        I initially included w based on the assumption that simultaneous job completion is not necessary in a restaurant context, but a small w (realistically, 2 or 3 minutes) is necessary to avoid cold food.
        However, testing various w values revealed that w=0 (i.e. all jobs in an order complete simultaneously) computes an optimal solution much faster than a nonzero w value.
        This is because w=0 exponentially reduces the number of nodes to be considered by the LP solver.

Changelog:
    v1.0 Initial Submission
    v1.01 Improved formatting and comments
    v1.02 Renamed for clarity.
    v1.03 Improved comments, removed whitespace


