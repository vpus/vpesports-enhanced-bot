import time

def getDistance(p1, p2):
    return ((p1[0] - p2[0])*(p1[0] - p2[0]) + (p1[1] - p2[1])*(p1[1] - p2[1]))**(1/2)

def samePoint(p1, p2):
    return p1[0] == p2[0] and p1[1] == p2[1]

def inGroup(group, point):
    for p in group:
        if p[0] == point[0] and p[1] == point[1]:
            return True
        
    return False

trees = [
    [400,550],
    [420,530],
    [300,450],
    [350,420],
    [475,500],
    [375,475],
    [325,520],
    [330,620],
    [450,425],
    [900,800],
    [920,850],
    [935,750],
    [950,775],
    [975,800],
    [850,700],
    [835,750],
    [900,700],
    [950,715],
    [850,850],
    [1200, 200]
]

# go through each point and check against every other point to see if the distance is close enough, if yes, group them

# for _ in range(0, 60):
# for point1 in trees:
#     group = [point1]
#     for point2 in trees:
#         dist = getDistance(point1, point2)
#         
#         if dist < 100 and not inGroup(group, point2):
#             group.append(point2)
#             for point3 in trees:
#                 dist2 = getDistance(point2, point3)
#                 
#                 if dist2 < 100 and not inGroup(group, point3):
#                     group.append(point3)
#     groups.append(group)
# print(time.time() - start)

# for group in groups:
#     for point in group:
#         print(str(point[0]) + ", " + str(point[1]))
#     print("-------------------------")

def cluster(points):
    clusters = []
    
    while points:
        s     = []
        queue = [points.pop()]
        while queue:
            tempQueue = []
            for p1 in queue:
                for p2 in points:
                    if not samePoint(p1, p2):
                        dist = getDistance(p1, p2)
                        
                        if dist < 100:
                            tempQueue.append(p2)
                
            for p1 in queue:
                if not inGroup(s, p1):
                    s.append(p1)
            
            queue = tempQueue;
            
            for p1 in tempQueue:
                for i,p2 in enumerate(points):
                    if samePoint(p1, p2):
                        del points[i]
                        break;
                    
        clusters.append(s)
    
    return clusters

start = time.time()
for _ in range(0,60):
    tempList = list(trees)
    clusters = cluster(tempList)

print(time.time() - start)
# for cluster in clusters:
#     for point in cluster:
#         print(str(point[0]) + ", " + str(point[1]))
#         
#     print("----------------------")
    