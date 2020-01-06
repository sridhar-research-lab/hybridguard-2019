import org.aspectj.lang.JoinPoint;
import android.util.Log;

public aspect TraceGen{
    before() : ! within(TraceGen){
        Log.d("UD-UNCC-TraceGen", "Enter: " +thisJoinPoint);
    }
    after() : ! within(TraceGen){
        Log.d("UD-UNCC-TraceGen", "Exit: " +thisJoinPoint);
    }
}