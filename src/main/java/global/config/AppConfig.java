package global.config;

import javax.sql.DataSource;

import org.flywaydb.core.Flyway;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.client.RestTemplate;

@Configuration
public class AppConfig {

	@Bean
	public RestTemplate restTemplate() {
		return new RestTemplate();
	}
	
	@Bean(initMethod = "migrate")
	public Flyway flyway(DataSource datasource) {
		return Flyway.configure()
				.dataSource(datasource)
				.locations("classpath:db")
				.baselineOnMigrate(true)
				.load();
		
	}

}
