import java.io.PrintStream;
import java.util.Random;

import weka.classifiers.Classifier;
import weka.classifiers.evaluation.Evaluation;
import weka.classifiers.lazy.IBk;
import weka.classifiers.trees.J48;
import weka.core.converters.ConverterUtils.DataSource;
import weka.core.matrix.LinearRegression;
import weka.filters.Filter;
import weka.filters.unsupervised.attribute.Remove;
import weka.core.Instances;
import weka.core.SerializationHelper;
import weka.core.Attribute;
import weka.core.AttributeStats;
import weka.core.DenseInstance;
import weka.core.Instance;

public class Iris {
    public static void main(String[] args) throws Exception {

//        runJ48();

//        System.out.println(classifyIris(1,1,1,1));
//        System.out.println(classifyIris(2,2,2,2));
//
//        runKNN(3);
//
//        runJ48RemovedCols();

        //trenovani modelu
        linear();
        //dotaz nad modelem
        System.out.println(regressTitanicAge(3,1,0,0, 7.55,0, 1));
        fillTitanicAgeData();
    }
    private static void fillTitanicAgeData() throws Exception{
        DataSource source = new DataSource("data/ageMissing.arff");
        Instances data = source.getDataSet();

        for(int i = 0; i < data.size(); i++){
            Instance att = data.get(i);
            //TODO set att[7]
            regressTitanicAge(att.value(0),att.value(1),att.value(2),att.value(3), att.value(4),att.value(5), att.value(6));
            System.out.println(att);
        }
    }


    private static void linear() throws Exception{
        // Load the Iris dataset from a file
        DataSource source = new DataSource("data/ageNotMissing.arff");
        Instances data = source.getDataSet();

        // Set the class attribute to the last attribute in the dataset
        data.setClassIndex(data.numAttributes() - 1);

        Classifier model = new weka.classifiers.functions.LinearRegression();

        Evaluation eval = new Evaluation(data);
        //only call the crossValidateModel with your classifier, on your dataset, with 10 fold, and random
        eval.crossValidateModel(model, data, 10, new Random(1));

        //print the results of 10 fold
        System.out.println(model);
        System.out.println(eval.toSummaryString());
        //System.out.println(eval.toMatrixString());
        //System.out.println(eval.toClassDetailsString());


        // Make final model
        model.buildClassifier(data);
        System.out.println(model);

        saveModel(model, "titanic-linear.model");
        saveHeader(data, "titanic-linear.header");
    }

    private static String regressTitanicAge(double pclass, double sex, double sibsp, double parch, double fare, double embarked, double survived_binarized) throws Exception{
        Classifier model = loadModel("titanic-linear.model");
        Instances header = loadHeader("titanic-linear.header");

        //budem zakladat novy radek o 8 atributech
        Instance newInstance  = new DenseInstance(8);
        //zalozeni radku
        newInstance.setDataset(header);
        //naplneni znamych atributu
        newInstance.setValue(0, pclass);
        newInstance.setValue(1, sex);
        newInstance.setValue(2, sibsp);
        newInstance.setValue(3, parch);
        newInstance.setValue(4, fare);
        newInstance.setValue(5, embarked);
        newInstance.setValue(6, survived_binarized);
        //vypocteni a ziskani posledniho pozadovaneho atributu
        double label = model.classifyInstance(newInstance);
        return ""+label;
    }

    private static void runJ48() throws Exception{
        // Load the Iris dataset from a file
        DataSource source = new DataSource("data/iris.arff");   
        Instances data = source.getDataSet();                 


        // Print the attribute stats
        int numAttributes = data.numAttributes();

        for (int i = 0; i < numAttributes; i++) {
            AttributeStats stats = data.attributeStats(i);

            System.out.println(data.attribute(i).name());
            System.out.println(stats);
        }


        // Set the class attribute to the last attribute in the dataset
        data.setClassIndex(data.numAttributes() - 1); 


        Classifier model = new J48();
        Evaluation eval = new Evaluation(data);
        //only call the crossValidateModel with your classifier, on your dataset, with 10 fold, and random
        eval.crossValidateModel(model, data, 10, new Random(1));

        //print the results of 10 fold
        //System.out.println(model);
        System.out.println(eval.toSummaryString());
        System.out.println(eval.toMatrixString());
        System.out.println(eval.toClassDetailsString());


        // Make final model
        model.buildClassifier(data);
        System.out.println(model);

        saveModel(model, "iris-j48.model");
        saveHeader(data, "iris-j48.header");
    }


    private static String classifyIris(double sepalL, double sepalW, double petalL, double petalW) throws Exception{
        Classifier model = loadModel("iris-j48.model");
        Instances header = loadHeader("iris-j48.header");

        Instance newInstance  = new DenseInstance(5);
        newInstance.setDataset(header);

        newInstance.setValue(0, sepalL);
        newInstance.setValue(1, sepalW);
        newInstance.setValue(2, petalL);
        newInstance.setValue(3, petalW);

        double label = model.classifyInstance(newInstance);
        String labelText = header.attribute(header.numAttributes() - 1).value((int) label);

        return labelText;
    }



    private static void runKNN(int k) throws Exception{
        // Load the Iris dataset from a file
        DataSource source = new DataSource("data/ageNotMissing.arff");
        //DataSource source = new DataSource("data/iris.arff");
        Instances data = source.getDataSet();                 

        // Set the class attribute to the last attribute in the dataset
        data.setClassIndex(data.numAttributes() - 1); 

        IBk model = new IBk();
        String[] options = new String[2];
        options[0] = "-K";                // # of nearest neighbors
        options[1] = ""+k ;
        model.setOptions(options);        // set the options


        Evaluation eval = new Evaluation(data);
        //only call the crossValidateModel with your classifier, on your dataset, with 10 fold, and random
        eval.crossValidateModel(model, data, 10, new Random(1));

        //print the results of 10 fold
        System.out.println(model);
        System.out.println(eval.toSummaryString());
        System.out.println(eval.toMatrixString());
        System.out.println(eval.toClassDetailsString());


        // Make final model
        model.buildClassifier(data);
        System.out.println(model);

        saveModel(model, "iris-knn.model");
        saveHeader(data, "iris-knn.header");
    }




    private static void runJ48RemovedCols() throws Exception{
        // Load the Iris dataset from a file
        DataSource source = new DataSource("data/iris.arff");   
        Instances data = source.getDataSet();                 


        // Remove attributes 1-2 (sepalW, sepalL)
        Remove remove = new Remove();                         
        String[] options = new String[2];
        options[0] = "-R";                                    // "range" 1-2
        options[1] = "1-2";                                    
        remove.setOptions(options);                           
        remove.setInputFormat(data);                          // inform filter about dataset **AFTER** setting options
        Instances newData = Filter.useFilter(data, remove);   // apply filter


        // Print the attribute stats
        int numAttributes = newData.numAttributes();
        for (int i = 0; i < numAttributes; i++) {
            AttributeStats stats = newData.attributeStats(i);
            System.out.println(stats);
        }

        // Set the class attribute to the last attribute in the dataset
        newData.setClassIndex(newData.numAttributes() - 1); 

        // Make final model
        Classifier model = new J48();
        model.buildClassifier(newData);
        System.out.println(model);
    }




    private static void saveModel(Classifier model, String filename) throws Exception{
        SerializationHelper.write(filename, model);
    }

    private static void saveHeader(Instances data, String filename) throws Exception{
        Instances header = new Instances(data, 0);
        SerializationHelper.write(filename, header);
    }

    private static Classifier loadModel(String filename) throws Exception{
        return (Classifier) SerializationHelper.read(filename);
    }

    private static Instances loadHeader(String filename) throws Exception{
        return (Instances) SerializationHelper.read(filename);
    }

}