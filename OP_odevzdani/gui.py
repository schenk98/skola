import tkinter as tk
from tkinter import ttk
from tkinter import filedialog
from tkinter.colorchooser import askcolor
import matplotlib.pyplot as plt
from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg
import numpy as np
import constants
import generateFunctions
from datetime import datetime
import sortingFunctions
import time


# GUI of the application
class GUIApp:
    def __init__(self,root):
        #colors of points drawn
        self.color1 = "#3366CC"  # Modrá
        self.color2 = "#9933CC"  # Fialová

        #points arrays initialization
        self.generatedPoints = np.empty([1,2])
        self.sortedPoints = np.empty([1,2])

        # Main frame
        self.root = root
        self.root.title("schenkj OP: Points generator")
                
        # Column for frame and for canvases init
        self.graphs_frame = ttk.Frame(self.root)
        self.graphs_frame.grid(row=1, column=0, sticky="nsew")

        #canvas for result visualization
        aspect_ratio = 1.0
        self.fig1, self.ax1 = plt.subplots(figsize=(6, 6 * aspect_ratio))
        self.canvas1 = FigureCanvasTkAgg(self.fig1, master=self.graphs_frame)
        self.canvas1.get_tk_widget().grid(row=0, column=0, padx=1, pady=20, sticky="nsew")
        #self.fig2, self.ax2 = plt.subplots(figsize=(6, 6 * aspect_ratio))
        #self.canvas2 = FigureCanvasTkAgg(self.fig2, master=self.right_frame)
        #self.canvas2.get_tk_widget().grid(row=0, column=1, padx=1, pady=20, sticky="nsew")

        # Generate top part - frame for all buttons, combo boxes and input
        self.top_block = ttk.Frame(self.root)
        self.top_block.grid(row=0, column=0, sticky="nsew")
        self.left_top_frame = ttk.Frame(self.top_block)
        self.left_top_frame.grid(row=0, column=0, sticky="nsew")

        # Labels
        label0 = ttk.Label(self.left_top_frame, text="Number of Points")
        #label1 = ttk.Label(self.left_top_frame, text="Area Shape")
        label2 = ttk.Label(self.left_top_frame, text="Type of Generation")
        label3 = ttk.Label(self.left_top_frame, text="Point A")
        label4 = ttk.Label(self.left_top_frame, text="Point B")
        self.label5 = ttk.Label(self.left_top_frame, text="Variance  ")

        label0.grid(row=0, column=0, padx=5, pady=5, sticky="w")
        #label1.grid(row=1, column=0, padx=5, pady=5, sticky="w")
        label2.grid(row=2, column=0, padx=5, pady=5, sticky="w")
        label3.grid(row=0, column=2, padx=5, pady=(5,0), sticky="w")
        label4.grid(row=1, column=2, padx=5, pady=(5,1), sticky="w")
        self.label5.grid(row=2, column=2, padx=5, pady=5, sticky="w")

        # Select Choices
        self.areaShapeGUI = ttk.Combobox(self.left_top_frame, values=["Rectangle", "Elipse"])
        self.areaShapeGUI.current(0)
        #self.generationTypeGUI = ttk.Combobox(self.left_top_frame, values=["Gaussian random", "Linear random", "Regular", "Hammersly", "Larcher-Pillichshammer", "Jittering", "Semi-Jittering", "N-Rooks", "Poisson-disc", "Mitchel", "Lloyd", "Simple CCPD"])
        self.generationTypeGUI = ttk.Combobox(self.left_top_frame, values=["Gaussian random", "Linear random", "Regular", "Hammersly", "Larcher-Pillichshammer", "Jittering", "Semi-Jittering", "N-Rooks", "Poisson-disc", "Lloyd", "Simple CCPD"])
        self.generationTypeGUI.current(0)
        self.generationTypeGUI.bind("<<ComboboxSelected>>", self.onFunctionChanged)
        #self.areaShapeGUI.grid(row=1, column=1, padx=5, pady=(5, 0), sticky="ew")
        self.generationTypeGUI.grid(row=2, column=1, padx=5, pady=5, sticky="ew")

        # Input Numbers
        self.numberOfPointsGUI = tk.Entry(self.left_top_frame)
        self.numberOfPointsGUI.insert(0,2500)
        self.points_frameA = ttk.Frame(self.left_top_frame)
        self.points_frameA.grid(row=0, column=3, padx=3, pady=5, sticky="ew")
        self.points_frameB = ttk.Frame(self.left_top_frame)
        self.points_frameB.grid(row=1, column=3, padx=3, pady=5, sticky="ew")
        self.pointAxGUI = tk.Entry(self.points_frameA, width=10)
        self.pointAxGUI.insert(0,100)
        self.pointBxGUI = tk.Entry(self.points_frameB, width=10)
        self.pointBxGUI.insert(0,200)
        self.pointAyGUI = tk.Entry(self.points_frameA, width=10)
        self.pointAyGUI.insert(0,100)
        self.pointByGUI = tk.Entry(self.points_frameB, width=10)
        self.pointByGUI.insert(0,200)        
        self.numberOfPointsGUI.grid(row=0, column=1, padx=5, pady=5, sticky="ew")
        self.pointAxGUI.grid(row=0, column=1, padx=3, pady=5, sticky="ew")
        self.pointBxGUI.grid(row=1, column=1, padx=3, pady=5, sticky="ew")
        self.pointAyGUI.grid(row=0, column=2, padx=3, pady=5, sticky="ew")
        self.pointByGUI.grid(row=1, column=2, padx=3, pady=5, sticky="ew")

        self.variableGUI = tk.Entry(self.left_top_frame, width=10)
        self.variableGUI.insert(0,20)
        self.variableGUI.grid(row=2, column=3, padx=5, pady=5, sticky="ew")

        # Generate Button
        self.generate_button = tk.Button(self.left_top_frame, text="Generate", bg="green", command=self.generateCMD)
        self.generate_button.grid(row=0, column=4, padx=20, pady=10, sticky="ew")

        # Save Button
        save_generated_button = tk.Button(self.left_top_frame, text="Save Generated", command=self.save)
        save_generated_button.grid(row=1, column=4, padx=20, pady=10, sticky="ew")

        # Load button
        load_button = tk.Button(self.left_top_frame, text="Load Points", command=self.load_file)
        load_button.grid(row=2, column=4, padx=20, pady=10, sticky="ew")

        """
        # Druhý sloupec (25%)
        self.right_top_frame = ttk.Frame(self.top_block, border=5)
        self.right_top_frame.grid(row=0, column=1, sticky="nsew")

        # Labels
        label6 = ttk.Label(self.right_top_frame, text="Sorting Type")
        label7 = ttk.Label(self.right_top_frame, text="Stop by Epsilon")
        label8 = ttk.Label(self.right_top_frame, text="Stop by Iteration")

        label6.grid(row=0, column=0, padx=(50,5), pady=5, sticky="w")
        label7.grid(row=1, column=0, padx=(50,5), pady=5, sticky="w")
        label8.grid(row=2, column=0, padx=(50,5), pady=5, sticky="w")

        # Select Options
        self.sorting_function = ttk.Combobox(self.right_top_frame, values=["Lloyd", "McQueen", "CVT"])
        self.sorting_function.insert(0,"CVT")
        self.epsilon = tk.Entry(self.right_top_frame)
        self.epsilon.insert(0,0.001)
        self.max_iter = tk.Entry(self.right_top_frame)
        self.max_iter.insert(0,1000)
        self.sorting_function.grid(row=0, column=1, padx=5, pady=(5, 0), sticky="ew")
        self.epsilon.grid(row=1, column=1, padx=5, pady=5, sticky="ew")
        self.max_iter.grid(row=2, column=1, padx=5, pady=5, sticky="ew")

        # Sort Button
        sort_button = tk.Button(self.right_top_frame, text="Sort", command=self.sort)
        sort_button.grid(row=0, column=2, padx=20, pady=10, sticky="ew")

         # Save Button
        save_sorted_button = tk.Button(self.right_top_frame, text="Save Sorted", command=self.saveSorted)
        save_sorted_button.grid(row=1, column=2, padx=20, pady=10, sticky="ew")
        

        # Tlačítko pro aktualizaci grafů
        update_graphs_button = tk.Button(self.right_top_frame, text="Update Graphs", command=self.updateGraphs)
        update_graphs_button.grid(row=2, column=2, padx=20, pady=10, sticky="ew")
        """


        # Weights for rows and columns
        self.root.grid_rowconfigure(0, weight=1)
        self.root.grid_columnconfigure(0, weight=1)
        self.root.grid_columnconfigure(1, weight=1)
        self.root.grid_columnconfigure(2, weight=2)

        # GUI start
        self.root.mainloop()

    # plots (1 for generating and 2 for sorting if need to be)
    fig1, ax1 = plt.subplots(figsize=(6, 4))
    fig2, ax2 = plt.subplots(figsize=(6, 4))

    #react with labels and button color on function change
    def onFunctionChanged(self,event):
        fce = constants.generateType[self.generationTypeGUI.get()]
        self.label5 = ttk.Label(self.left_top_frame, text="Variance")
        # if is called function with no need for third variable and short computation time
        if fce == constants.LINEAR or fce == constants.REGULAR or fce == constants.HAMMERSLY or fce == constants.LP or fce == constants.N_ROOKS:
            # disable third variable input field and set label text to blank
            self.variableGUI.configure(state="disabled")
            self.label5.config(text="") 
            self.label5 = ttk.Label(self.left_top_frame, text="                ")
            self.label5.grid(row=2, column=2, padx=5, pady=5, sticky="w")
            self.left_top_frame.update()
            # color for button turn green - short computation time
            self.generate_button.grid_remove()
            self.generate_button = tk.Button(self.left_top_frame, text="Generate", bg="green", command=self.generateCMD)
            self.generate_button.grid(row=0, column=4, padx=20, pady=10, sticky="ew")
        # for gaussian random - set label on variance, thirt variable field on enabled and button on green for short computation time
        elif fce == constants.GAUSS:
            self.variableGUI.configure(state="normal")
            self.label5.config(text="") 
            self.label5 = ttk.Label(self.left_top_frame, text="Variance  ")
            self.label5.grid(row=2, column=2, padx=5, pady=5, sticky="w")            
            self.left_top_frame.update()
            self.generate_button.grid_remove()
            self.generate_button = tk.Button(self.left_top_frame, text="Generate", bg="green", command=self.generateCMD)
            self.generate_button.grid(row=0, column=4, padx=20, pady=10, sticky="ew")
        # for jittering and semi-jittering set label to jitter (for jitter strength) and enable third variable input field, set button on green for short computation time
        elif fce == constants.JITTER or fce == constants.SEMI_JITTER:
            self.variableGUI.configure(state="normal")
            self.label5.config(text="") 
            self.label5 = ttk.Label(self.left_top_frame, text="Jitter        ")
            self.label5.grid(row=2, column=2, padx=5, pady=5, sticky="w")
            self.left_top_frame.update()
            self.generate_button.grid_remove()
            self.generate_button = tk.Button(self.left_top_frame, text="Generate", bg="green", command=self.generateCMD)
            self.generate_button.grid(row=0, column=4, padx=20, pady=10, sticky="ew")
        # for Lloyd and CCPD as third argument take maximal iterations (set label and input field accordingly), 
        # set button on orange for longer computational time when iteration is greater than constants.maxIter and green for short computational time when it is less
        elif fce == constants.LLOYD or fce == constants.CCPD:
            self.variableGUI.configure(state="normal")
            self.label5.config(text="") 
            self.label5 = ttk.Label(self.left_top_frame, text="Iterations")
            self.label5.grid(row=2, column=2, padx=5, pady=5, sticky="w")
            self.left_top_frame.update()
            self.generate_button.grid_remove()
            self.generate_button = tk.Button(self.left_top_frame, text="Generate", bg="green", command=self.generateCMD)
            self.generate_button.grid(row=0, column=4, padx=20, pady=10, sticky="ew")
            if int(self.variableGUI.get())>constants.MAX_ITER_BUTTON_COLOR:
                self.generate_button.grid_remove()
                self.generate_button = tk.Button(self.left_top_frame, text="Slowly Generate", bg="orange", command=self.generateCMD)
                self.generate_button.grid(row=0, column=4, padx=20, pady=10, sticky="ew")
        # for Mitchell set button color to red (for really long computational time) and disable third variable and label
        elif fce == constants.MITCHEL:
            self.variableGUI.configure(state="disabled")
            self.label5.config(text="") 
            self.label5 = ttk.Label(self.left_top_frame, text="                ")
            self.label5.grid(row=2, column=2, padx=5, pady=5, sticky="w")
            self.generate_button.grid_remove()
            self.generate_button = tk.Button(self.left_top_frame, text="Slowly Generate", bg="red", command=self.generateCMD)
            self.generate_button.grid(row=0, column=4, padx=20, pady=10, sticky="ew")
            self.left_top_frame.update()
        # disable third variable input field and set button on orange for longer computational time
        elif fce == constants.POISSON:
            self.variableGUI.configure(state="disabled")
            self.label5.config(text="") 
            self.label5 = ttk.Label(self.left_top_frame, text="                ")
            self.label5.grid(row=2, column=2, padx=5, pady=5, sticky="w")
            self.generate_button.grid_remove()
            self.generate_button = tk.Button(self.left_top_frame, text="Slowly Generate", bg="orange", command=self.generateCMD)
            self.generate_button.grid(row=0, column=4, padx=20, pady=10, sticky="ew")
            self.left_top_frame.update()
        # else for any misshaps or new functions set input field on "Variable" and enable it, set button on gree for default short computational time
        else:
            self.variableGUI.configure(state="normal")
            self.label5.config(text="") 
            self.label5 = ttk.Label(self.left_top_frame, text="Variable  ")
            self.label5.grid(row=2, column=2, padx=5, pady=5, sticky="w")
            self.left_top_frame.update()
            self.generate_button.grid_remove()
            self.generate_button = tk.Button(self.left_top_frame, text="Generate", bg="green", command=self.generateCMD)
            self.generate_button.grid(row=0, column=4, padx=20, pady=10, sticky="ew")

    # function called from "Generate" button for initialization of generating
    def generateCMD(self):
        
        # if there were usage for differently shaped areas
        if self.areaShapeGUI.get()=="Rectangle":
            areaShape = constants.RECTANGLE
        elif self.areaShapeGUI.get()=="Elipse":
            areaShape = constants.ELIPSE
        else:
            areaShape=3
            exit(3)
        
        # get generating function and exit on fail
        genType = constants.generateType[self.generationTypeGUI.get()]
        if genType < 0:
            exit(4)
        
        # get points of area, start timer and start generating
        pointAGUI = [float(self.pointAxGUI.get()),float(self.pointAyGUI.get())]
        pointBGUI = [float(self.pointBxGUI.get()),float(self.pointByGUI.get())]
        start_time = time.time()
        self.area_for_points, self.generatedPoints = generateFunctions.generate(int(self.numberOfPointsGUI.get()), areaShape, genType, pointAGUI, pointBGUI, float(self.variableGUI.get()))
        # stop time, print statistics and show result
        end_time = time.time()
        duration = end_time - start_time
        print(f"#points: {len(self.generatedPoints)}({int(self.numberOfPointsGUI.get())})\nGENERATE FUNCTION: {self.generationTypeGUI.get()}\nArea size: {abs(self.area_for_points.maxX-self.area_for_points.minX)}|{abs(self.area_for_points.maxY-self.area_for_points.minY)}\nVariable: {float(self.variableGUI.get())}\nDURATION: {duration} sec\n---------------------------------------------------------------------")
        self.updateGraphs()

    # for reading files
    def load_file(self):
        file_path = filedialog.askopenfilename()
        # Read point cloud data from file
        with open(file_path, 'r') as file:
            first_line = file.readline().strip()
            if first_line.count(" ") > 1 and first_line.count(".") > 1:
                file.close
                file = open(file_path, 'r')
            x, y = [], []
            for line in file:
                a, b = map(float, line.strip().split())
                x.append(a)
                y.append(b)

        # Convert data to numpy arrays
        self.generatedPoints = np.array([x, y]).T
        self.updateGraphs()    

    # placeholder for sorting if needed
    def sort(self):
        if self.sorting_function == "Lloyd":
            self.sortedPoints = sortingFunctions.lloyd(self.area_for_points, self.generatedPoints.copy(), self.epsilon, self.max_iter)
        elif self.sorting_function == "McQueen":
            self.sortedPoints = sortingFunctions.mcQueen(self.area_for_points, self.generatedPoints.copy(), self.epsilon, self.max_iter)
        elif self.sorting_function == "CVT":
            self.sortedPoints = sortingFunctions.cvt(self.area_for_points, self.generatedPoints.copy(), self.epsilon, self.max_iter)

        self.updateGraphs()

    # Reloading graphs and canvases
    def updateGraphs(self):
        self.ax1.clear()
        self.ax1.scatter(self.generatedPoints[:, 0], self.generatedPoints[:, 1], s=0.5, c=self.color1)
        self.ax1.set_xlabel('X')
        self.ax1.set_ylabel('Y')
        self.canvas1.draw()  # Aktualizace grafu

        """
        self.ax2.clear()
        self.ax2.scatter(self.sortedPoints[:, 0], self.sortedPoints[:, 1], s=0.5, c=self.color2)
        self.ax2.set_xlabel('X')
        self.ax2.set_ylabel('Y')
        self.canvas2.draw()  # Aktualizace grafu
        """

    # function for saving generated points and graph
    def save(self):
        now = datetime.now()
        genType = self.generationTypeGUI.get()
        formatted_datetime = now.strftime("%M%H%d%m%y")
        with open("savedPoints/generated_{}_{}.txt".format(genType,formatted_datetime), 'w') as file:
            file.write("{}\n".format(len(self.generatedPoints)))
            for p in self.generatedPoints:
                str = ("{} {}\n".format(p[0],p[1]))
                file.write(str)
            file.close()
         # Save graph
        self.fig1.savefig("savedPoints/plot_{}_{}.png".format(genType,formatted_datetime), dpi=300)
        
    # placeholder for saving function for sorted data
    def saveSorted(self):
        now = datetime.now()
        formatted_datetime = now.strftime("%S%M%H%d%m%y")
        with open("savedPoints/s{}.txt".format(formatted_datetime), 'w') as file:
            file.write("{}\n".format(len(self.sortedPoints)))
            for p in self.sortedPoints:
                str = ("{} {}\n".format(p[0],p[1]))
                file.write(str)
            file.close()

        