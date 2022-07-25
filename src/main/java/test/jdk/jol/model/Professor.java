package test.jdk.jol.model;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

/**
 * @author : xiaozhang
 * @since : 2022/7/8 11:56
 */

public class Professor {

    private String name;
    private boolean tenured;
    private List<Course> courses = new ArrayList<>();
    private int level;
    private long time;
    private double lastEvaluation;
}
