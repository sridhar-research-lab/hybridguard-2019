import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.After;
import org.aspectj.lang.annotation.Pointcut;
import android.util.Log;
/**
* Created by fAlc0n on 12/22/16.
*/

 /*
 @Aspect
 public aspect log {
 pointcut anyCallOrExecution(): call(* *.*(..)) && execution(* *.*(..));

 after(): anyCallOrExecution(..) {
 Log.d("UD-UNCC","call="+thisJoinPoint.getSignature()+";source="+thisJoinPoint.getSourceLocation());

 }
 }
 */
@Aspect
public class AspectLogger {

    public AspectLogger() {
        Log.d("Aspect j","In AspectLogger");
    }

    @Pointcut("call(* *.*(..))")
    void log()
    {
        Log.d("Aspect J","The function is ");
    }

    @After("call(* *.*(..))")
    public void logAfter(JoinPoint joinPoint) {
        Log.d("UD-UNCC","call="+joinPoint.getSignature()+";source="+joinPoint.getSourceLocation());
        Log.d("Aspect J","logAfter() is running!");
        Log.d("Aspect J","hijacked : " + joinPoint.getSignature().getName());
    }
}
