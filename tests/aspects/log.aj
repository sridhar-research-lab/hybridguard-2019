import org.aspectj.lang.JoinPoint;
//import android.*;
import android.util.Log;

public aspect log {
    //pointcut anyCallOrExecution(): (execution(* *.*(..)) && !cflow(within(log)));
    //pointcut anyCallOrExecution(): (cflow (call(* *.*(..))) && !cflow(within(log)));

    pointcut anyCallOrExecution() : (call(* *.*(..)) || execution(* *.*(..)))
                        && !within(log)
                        && !within(Log);
 
    after(): anyCallOrExecution() {
		Log.d("UD-UNCC","call="+thisJoinPoint.getSignature()+";source="+thisJoinPoint.getSourceLocation());    	
    }
} 