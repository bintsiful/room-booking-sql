# Room Booking SQL - Multiple Approaches to Availability Problems

This project demonstrates 4 different approaches to solving room/bed availability problems in Oracle SQL, with performance analysis and optimization techniques.

## Project Overview

The project highlights the trade-offs between simplicity, accuracy, and performance when modeling room booking systems. It includes schema design patterns, query optimization strategies, and practical examples.

Read the blog here: [What a Room Booking Question on Oracle Forums Taught Me About Data Modeling in Oracle APEX](https://bintsiful.hashnode.dev/what-a-room-booking-question-on-oracle-forums-taught-me-about-data-modeling-in-oracle-apex)

## Files Overview

### Approach 1: Basic Overlap Logic
- **01_schema_original.sql** - Initial schema design with basic room booking structure
- **02_sample_data.sql** - Sample data for testing and demonstrations
- **03_basic_overlap.sql** - Simple overlap checking logic for availability

### Approach 2: Daily Occupancy Expansion
- **04_query_dail_occupancy.sql** - Daily occupancy expansion approach for more granular queries

### Approach 3: Interval Boundary Optimization
- **05_query_interval_boundary.sql** - Interval boundary optimization for efficient date range queries

### Approach 4: Proper Data Modeling
- **06_schema_improved.sql** - Improved schema with explicit bed tracking
- **07_sample_data_improved.sql** - Sample data for the improved schema
- **08_query_explicit_beds.sql** - Queries using explicit bed modeling for accuracy

### Performance Analysis
- **09_performance_analysis.sql** - Comprehensive performance analysis, benchmarking, and optimization recommendations

## Key Features

1. **Multiple Approaches** - Compare different SQL strategies for solving the same problem
2. **Performance Analysis** - Benchmarking different approaches to identify the most efficient solution
3. **Schema Evolution** - See how data modeling impacts query performance and accuracy
4. **Practical Examples** - Real-world room booking scenarios with test data

## How to Use

1. Set up your Oracle database
2. Run the SQL files in sequence to understand each approach
3. Use the performance analysis file to benchmark and compare approaches
4. Choose the best approach for your specific use case

## Trade-offs

- **Simplicity vs Accuracy** - Simple overlap logic vs proper data modeling
- **Query Performance** - Different query strategies have varying performance characteristics
- **Scalability** - Consider volume when choosing your approach

---

For detailed explanations and performance metrics, refer to the blog post linked above.
