import numpy as np


class Simulate:
    def __init__(self,lane, pos, speed, type ):
        self.number = 0
        self.car_list = []  # [[pos，distance(与前面车）,speed,type],[]]
        for i in range(len(pos)):
            self.car_list.append((pos[i], 0.0, speed[i], type[i]))
        #print(self.car_list)
        self.lane_num = lane
        self.car_list = np.array(self.car_list,dtype=[('pos',float),('distance',float),('speed',float),('type',int)])
        self.car_list=np.reshape(self.car_list,(3,1))
        print(np.shape(self.car_list),'test')
        print(np.shape(self.car_list[1:]))
        self.car_list_copy = np.append(self.car_list[1:],[(-1.0,-1.0,-1.0,-1),0])[0:-1]
        #np.concatenate([self.car_list,[(float(-1.0),float(-1.0),float(-1.0),int(-1))]],axis=0)
        #print(np.shape(self.car_list))
        #dis = self.car_list_copy[:,0] - self.car_list[:,0]
        #self.car_list[:,1] = dis
        #print(self.car_list_copy)
    def add_car(self, pos, speed, type):
        '''All Input are dict'''
        for i in range(len(pos)):
            self.car_list = np.append(self.car_list,[[pos[i], 0, speed[i], type[i]]],axis=0)
        #self.car_list.sort(axis=0)

    def distance_init(self):
        last_pos = 0
        for car in self.car_list:
            self.car_distance.app = car.pos - last_pos
            last_pos = car.pos

    def step(self):
        for car in self.car_list:
            pass


road = Simulate(3,[10.0,20.0,30.0],[60.0,65.0,65.0],[0,0,0]) #pos ,speed ,type
#road.add_car([23,44,50],[55,50,60],[0,0,0])
#print(road.car_list,"pos，distance(与前面车）,speed,type")