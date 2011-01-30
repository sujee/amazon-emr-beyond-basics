package amazonemr;

import java.net.URI;
import java.util.Enumeration;
import java.util.Properties;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.conf.Configured;
import org.apache.hadoop.fs.FSDataInputStream;
import org.apache.hadoop.fs.FileSystem;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.util.Tool;
import org.apache.hadoop.util.ToolRunner;

public class ParseProperties extends Configured implements Tool
{
    public static void main(String[] args) throws Exception
    {
        int res = ToolRunner.run(new Configuration(), new ParseProperties(), args);
        System.exit(res);
    }

    @Override
    public int run(String[] args) throws Exception
    {

        if (args.length < 1)
        {
            System.err.printf("Usage: %s <config file>\n", getClass().getSimpleName());
            // ToolRunner.printGenericCommandUsage(System.err);
            return -1;
        }
        Configuration conf = getConf();

        String configFileLocation = args[0];
        Path configFilePath = new Path(configFileLocation);
        FileSystem fs = FileSystem.get(URI.create(configFileLocation),  conf);

        FSDataInputStream fdis = fs.open(configFilePath);
        Properties props = new Properties();
        props.load(fdis);
        System.out.println("Loaded Properties:\n" + props.toString());

        // set the properties into Config object so it is available for Mappers and Reducers
        Enumeration keys = props.propertyNames();
        while (keys.hasMoreElements())
        {
            String key = (String) keys.nextElement();
            String value = props.getProperty(key);
            conf.set(key, value);
        }

        // setup a job using the configuration
        Job job = new Job(conf, "MyJob");
        // other job setup goes here...
        boolean status = bidJob.waitForCompletion(true);
        return status ? 0 : 1;
    }
}

