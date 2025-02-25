import numpy as np
import pointsProcessing

#move points so they are in best fit plane
def project_points_onto_plane(points, normal):
    # Normalize the normal vector
    normalized_normal = normal / np.linalg.norm(normal)
    # Compute the projection matrix
    projection_matrix = np.eye(3) - np.outer(normalized_normal, normalized_normal)
    # Project the points onto the plane
    projected_points = points @ projection_matrix
    return projected_points



#project points into best fit plane making them 2D with minimized error and rotate that plane into x,y with all points having z=0
def projectPoints(criticalPoints):
    #find the best fit plane for given points
    planeNormalVector = pointsProcessing.getNormalOfBestFitPlane(criticalPoints)    
    
    resultPoints = project_points_onto_plane(criticalPoints, planeNormalVector)
    return resultPoints

#moves points towards [0,0,0]
def moveToZero(points, mins):
    for p in points:
        p[0]-= mins[0]
        p[1]-= mins[1]
        p[2]-= mins[2]
    return points

#moves points to point
def moveBackToMin(points, mins):
    for p in points:
        p[0]+= mins[0]
        p[1]+= mins[1]
        p[2]+= mins[2]
    return points

#rotates points via given vectors
def rotatePlane(points, v1, v2=[0,0,1]):
    if np.allclose(v1, v2):
        return points
    # Define the normal vector of your plane
    normal_vector = v1  # Example normal vector

    # Normalize the normal vector
    normal_vector /= np.linalg.norm(normal_vector)

    # Compute the rotation angle
    rotation_angle = np.arccos(np.dot(normal_vector, v2) / (np.linalg.norm(normal_vector) * np.linalg.norm(v2)))

    # Compute the rotation axis using cross product
    rotation_axis = np.cross(normal_vector, v2)
    rotation_axis /= np.linalg.norm(rotation_axis)

    # Compute the rotation matrix using the Rodrigues' rotation formula
    c = np.cos(rotation_angle)
    s = np.sin(rotation_angle)
    rotation_matrix = np.array([[c + rotation_axis[0]**2 * (1 - c), 
                                 rotation_axis[0] * rotation_axis[1] * (1 - c) - rotation_axis[2] * s,
                                 rotation_axis[0] * rotation_axis[2] * (1 - c) + rotation_axis[1] * s],
                                [rotation_axis[1] * rotation_axis[0] * (1 - c) + rotation_axis[2] * s,
                                 c + rotation_axis[1]**2 * (1 - c),
                                 rotation_axis[1] * rotation_axis[2] * (1 - c) - rotation_axis[0] * s],
                                [rotation_axis[2] * rotation_axis[0] * (1 - c) - rotation_axis[1] * s,
                                 rotation_axis[2] * rotation_axis[1] * (1 - c) + rotation_axis[0] * s,
                                 c + rotation_axis[2]**2 * (1 - c)]])

    # Rotate the points
    rotated_points = np.dot(rotation_matrix, points.T).T

    return rotated_points


#get normal of points
def getNormal(points):
    corners = pointsProcessing.getPointsForPlaneConstruction(points)
    v1 = corners[1] - corners[0]
    v2 = corners[2] - corners[0]
    
    # Calculate the cross product of the two vectors
    normal_vector = np.cross(v1, v2)
    
    # Normalize the normal vector
    normal_vector /= np.linalg.norm(normal_vector)
    for i in range(0,3):
        if normal_vector[i]==-0:
            normal_vector[i]=0
    
    return normal_vector
    
#add z=0 to 2D points
def transform_to_3d(data_2d):
    # Extract x and y coordinates from 2D data
    x = data_2d[:, 0]
    y = data_2d[:, 1]
    
    # Create z coordinate with zeros
    z = np.zeros_like(x)
    
    # Stack x, y, and z coordinates to form 3D data
    data_3d = np.column_stack((x, y, z))
    
    return data_3d