import java.util.logging.ConsoleHandler
import java.util.logging.LogManager

def logger = LogManager.getLogManager().getLogger("hudson.WebAppMain")
logger.addHandler (new ConsoleHandler())
